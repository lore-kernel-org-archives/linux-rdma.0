From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 6/7] IB/rxe: Avoid missed completions in the CM/MAD
Date: Tue, 22 Nov 2016 19:14:35 +0200
Message-ID: <CAG9sBKN3UAwO1X3JQ=n2AAUvB6r6dHPDuksaNHXCO9rBXj_Yjg@mail.gmail.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com> <1479479809-10798-6-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-6-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 4:36 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> The MAD code uses the IB_CQ_REPORT_MISSED_EVENTS flag to avoid a
> race between posting CQEs and arming the CQ. Without this fix, the
> last completion might be left on the CQ, hanging the kthread
> waiting on MAD to complete.
> See ib_cq_poll_work().
>
Looks OK but I would edit the commit message a bit. This fix is
relevant not only for MAD and not only for workqueue polling context.
For example, iSER allocates CQ with SOFTIRQ polling context and is
also exposed to this bug (see ib_poll_handler)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
