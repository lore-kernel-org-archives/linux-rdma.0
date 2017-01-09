From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 10/15] IB/rxe: Introduce functions for queue draining
Date: Mon, 9 Jan 2017 15:11:16 +0000
Message-ID: <D4991202.909C%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353661.3592.32.camel@sandisk.com> <D49910D0.9088%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D49910D0.9088%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Content-Language: en-US
Content-ID: <D1863D9378EE5443B68CBCA5E6C9A6B3-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/9/17, 10:06 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Boyer,
Andrew" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
Andrew.Boyer-8PEkshWhKlo@public.gmane.org> wrote:
>On 1/2/17, 5:42 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>
>>This change makes the code easier to read and avoids that code is
>>duplicated.
>>
>>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>>---
>> drivers/infiniband/sw/rxe/rxe_comp.c | 63
>>+++++++++++++-----------------------
>> drivers/infiniband/sw/rxe/rxe_resp.c | 28 ++++++++--------
>> 2 files changed, 38 insertions(+), 53 deletions(-)
...
>>
>> }
>>=20
>>+static void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
>
>Is notify unused? Is it here just for symmetry with the responder?

Never mind, I see it used in patch 11.

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
