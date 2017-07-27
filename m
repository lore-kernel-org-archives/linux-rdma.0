From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 2/7] IB/rxe: Disable completion upcalls when a CQ is
 destroyed
Date: Thu, 27 Jul 2017 13:19:44 +0000
Message-ID: <D59F5A05.1B7C0%Andrew.Boyer@emc.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1500989968-30889-3-git-send-email-andrew.boyer@dell.com>
 <CAG9sBKOet0xv9YaJAc58erVrnTGwzMd630goDgrxUEx4PhXK+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKOet0xv9YaJAc58erVrnTGwzMd630goDgrxUEx4PhXK+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <57CB8D56B6F1C2499227CB7C881CD50A-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hubbe, Allen" <Allen.Hubbe-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/27/17, 5:35 AM, "monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of Moni Shoua"
<monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>wrote:
>> This prevents the stack from accessing userspace objects while they
>> are being torn down.
>>
>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_cq.c    | 19 +++++++++++++++++++
>>  drivers/infiniband/sw/rxe/rxe_loc.h   |  2 ++
>>  drivers/infiniband/sw/rxe/rxe_verbs.c |  2 ++
>>  drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
>>  4 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c
>>b/drivers/infiniband/sw/rxe/rxe_cq.c
>> index 49fe42c..c4aabf7 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_cq.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_cq.c
>> @@ -69,6 +69,14 @@ int rxe_cq_chk_attr(struct rxe_dev *rxe, struct
>>rxe_cq *cq,
>>  static void rxe_send_complete(unsigned long data)
>>  {
>>         struct rxe_cq *cq =3D (struct rxe_cq *)data;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&cq->cq_lock, flags);
>> +       if (cq->is_dying) {
>> +               spin_unlock_irqrestore(&cq->cq_lock, flags);
>> +               return;
>> +       }
>> +       spin_unlock_irqrestore(&cq->cq_lock, flags);
>What if CQ is destroyed here after you pass the is_dying test?
>Maybe you should think of a solution based on ref counting.
>>         cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>>  }

Hello Moni,
Thank you for all of the reviews. I=B9ll address commit messages etc. in a
revised series.

This is the situation that causes a crash here:
 - Userspace programs exits
 - ib_uverbs_cleanup_ucontext() runs, calling ib_destroy_qp(),
ib_destroy_cq(), etc. and releasing/freeing the UCQ
   - The QP still has tasklets running, so it isn=B9t destroyed yet
   - The CQ is referenced (twice) by the QP, so the CQ isn=B9t destroyed ye=
t
   - The UCQ is kfree()'d!
 - A send work request completes
 - rxe_send_complete() calls cq->ibcq.comp_handler()
 - ib_uverbs_comp_handler() runs and crashes; the event queue is checked
for is_closed, but it has no way to check the ib_ucq_object

As you can see, the reference counting on the CQ doesn=B9t protect us.
There=B9s no interface I could find that would deregister the UCQ from the
CQ. I didn=B9t think attempting to add reference counting to the UCQ was
going to be a good way to go since the solution I posted above is so much
simpler (if hacky).

It looks like ib_uverbs_cleanup_context() is gone in 4.12. I don=B9t know i=
f
whatever replaced it addresses this issue already, by accident or by
design.

Does this make sense? Do you have a better idea for a fix?

Thank you,
Andrew

P.S. Sorry for the Outlook garbage formatting.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
