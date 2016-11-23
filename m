From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/8] RXE improvements
Date: Wed, 23 Nov 2016 19:59:17 +0200
Message-ID: <CAG9sBKMkoCbeCO6SgPZrW-x0rBNTQUaar+wAqeVDTLeoT8HfHw@mail.gmail.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Andrew Boyer (8):
>   IB/rxe: Remove buffer used for printing IP address
>   IB/rxe: Advance the consumer pointer before posting the CQE
>   IB/rxe: Don't update the response PSN unless it's going forwards
>   IB/rxe: Unblock loopback by moving skb_out increment
>   IB/rxe: Add support for zero-byte operations
>   IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
>   IB/rxe: Fix ref leak in rxe_create_qp()
>   IB/rxe: Fix ref leak in duplicate_request()

Thanks for the series.

Please see comment in response for the first patch but except that

Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

for everything else
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
