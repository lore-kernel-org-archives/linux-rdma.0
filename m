From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 08/9] ib/iser: move to use libiscsi passthrough mode
Date: Thu, 04 Feb 2010 11:27:22 -0600
Message-ID: <4B6B037A.4090502@cs.wisc.edu>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>	<Pine.LNX.4.64.1002031740540.11944@zuben.voltaire.com> <4B69EB5A.4050301@cs.wisc.edu> <4B6AADD4.2050607@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6AADD4.2050607-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/04/2010 05:21 AM, Or Gerlitz wrote:

>
> [PATCH V2 08/9] ib/iser: move to use libiscsi passthrough mode
>
> The libiscsi passthrough mode invokes the transport xmit calls directly
> without first going through an internal queue as done in the other mode
> which uses a queue and a xmitworker thread. Now when the "cant_sleep"
> prerequisite of iscsi_host_alloc is met, move to use it. Handling xmit
> errors is now done by  the passthrough flow of libiscsi. Since the
> queue/worker aren't used in this mode, the code that schedules the
> xmitworker is removed.
>
> Signed-off-by: Or Gerlitz<ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> ---
>
> changes from V1:
>
> - remove calls to iscsi_conn_failure which are under now both buggy and not needed, instead
>    return errors to libiscsi (e.g iscsi_queuecommand, __iscsi_conn_send_pdu)
> - enhance/fix the two debug prints and the change log
>

Looks ok.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
