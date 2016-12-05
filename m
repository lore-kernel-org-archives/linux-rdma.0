From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v2 0/8] RXE improvements
Date: Mon, 5 Dec 2016 13:58:12 +0000
Message-ID: <D46ADB9D.7D50%Andrew.Boyer@emc.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
 <CAG9sBKMkoCbeCO6SgPZrW-x0rBNTQUaar+wAqeVDTLeoT8HfHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKMkoCbeCO6SgPZrW-x0rBNTQUaar+wAqeVDTLeoT8HfHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <FB1647A6460314409125A631A7FE9573-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/23/16, 12:59 PM, "monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of Moni Shoua"
<monisonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org on behalf of monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>> Andrew Boyer (8):
>>   IB/rxe: Remove buffer used for printing IP address
>>   IB/rxe: Advance the consumer pointer before posting the CQE
>>   IB/rxe: Don't update the response PSN unless it's going forwards
>>   IB/rxe: Unblock loopback by moving skb_out increment
>>   IB/rxe: Add support for zero-byte operations
>>   IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
>>   IB/rxe: Fix ref leak in rxe_create_qp()
>>   IB/rxe: Fix ref leak in duplicate_request()
>
>Thanks for the series.
>
>Please see comment in response for the first patch but except that
>
>Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>for everything else

Hello Moni,
I saw the comment from Bart in response to the first patch, but I prefer
it this way because of how much other code is required to take advantage
of %pIS. If you want it changed to %pIS, we can do that, though. What
would you prefer?

-Andrew

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
