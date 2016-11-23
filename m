From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/7] IB/rxe: Add support for zero-byte operations
Date: Wed, 23 Nov 2016 17:04:49 +0200
Message-ID: <CAG9sBKPQSyGh8v1LjhWrNQ2fAixruWEkvJuEsJNdi8aqbr7bqQ@mail.gmail.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com> <1479479809-10798-5-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-5-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 4:36 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> The last_psn algorithm fails in the zero-byte case: it calculates
> first_psn = N, last_psn = N-1. This makes the operation unretryable since
> the res structure will fail the (first_psn <= psn <= last_psn) test in
> find_resource().
>
> While here, use BTH_PSN_MASK to mask the calculated last_psn.
>
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
