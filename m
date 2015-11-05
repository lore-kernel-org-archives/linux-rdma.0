From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Allow legacy verbs through extended interfaces
Date: Thu, 5 Nov 2015 17:12:51 +0200
Message-ID: <20151105151251.GA33200@x-vnc01.mtx.labs.mlnx>
References: <20151104193621.GA30146@x-vnc01.mtx.labs.mlnx>
 <1446720117.10170.35.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446720117.10170.35.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 11:41:57AM +0100, Yann Droneaud wrote:
> 
> Those checks were written with the assumption the command and flags
> masks could be different between the legacy and the new verb format.
> 
> But since it did happen (yet), it's ok to avoid the duplication (I
> would have prefer a separate preliminary patch for this).

OK, will send in a different patch.
> 
> 
> 
> What about IB_USER_VERBS_CMD_THRESHOLD instead of
>  IB_USER_VERBS_CMD_OPEN_QP ?
> 
I wanted to be more restrictive here. After all there can't be any
more legacy commands.
> > +		    !(ib_dev->uverbs_ex_cmd_mask & (1ull <<
> > command))) {
> >  			ret = -ENOSYS;
> >  			goto out;
> >  		}
> 
> 
> uverbs_ex_cmd_table[] has already been looked up at this point, so that
> can only work if uverbs_ex_cmd_table[] is extended to support the
> legacy verbs.
> 
> Currently there's only two verbs with dual implementation
> 
>   IB_USER_VERBS_EX_CMD_QUERY_DEVICE
>   IB_USER_VERBS_EX_CMD_CREATE_CQ
> 
> 
> If we want to have a 1:1 mapping legacy verbs as extended verbs, then I
> would suggest to check the legacy mask to not allow a legacy verb not
> supported by the hw provider to be called:
> 
> 	if (! (((command <= IB_USER_VERBS_CMD_OPEN_QP) ?
> 		 ib_dev->uverbs_cmd_mask :
> 		 ib_dev->uverbs_ex_cmd_mask) & (1 ull << command))) {
> 		ret = -ENOSYS;
> 		goto out;
> 	}
> 
Yes this looks even safer. So I will apply this idea and re-send.

> Perhaps we could drop uverbs_ex_cmd_mask and set bit for extended verbs
> in uverbs_cmd_mask instead. Then, there will be no need to check againt
> the command threshold.
> 
> Anyway, this is a new assumption that extended verbs will have to be
> somewhat retro compatible with the legacy hw provider implementation
> used by the legacy verbs they intend to replace: an extended verbs
> matching a legacy one will need to be written in such way it will not
> be calling into a hw provider function pointer that can be NULL (in
> case there's new function pointer is added for an updated verbs in
> struct ib_device  while we keep in place the legacy one ... but for in
> -kernel drivers that should never happen: it usual better to replace
> the previous one by the newer and the existing drivers have to be
> updated to provide the new function and remove the previous one, so I
> think it's quite safe).
> 
> Regards.
> 
> -- 
> Yann Droneaud
> OPTEYA
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
