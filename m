From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 08:28:03 -0400
Message-ID: <1500812883.2610.7.camel@redhat.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
         <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
         <20170530054609.GG17751@mtr-leonro.local>
         <20170723073905.GE3259@mtr-leonro.local>
         <20170723074153.GF3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170723074153.GF3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-07-23 at 10:41 +0300, Leon Romanovsky wrote:
> On Sun, Jul 23, 2017 at 10:39:05AM +0300, Leon Romanovsky wrote:
> > On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
> > > On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro
> > > wrote:
> > > > From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > 
> > > > Playing with IP-O-IB interface can trigger a warning message:
> > > > "ib0: Failed to modify QP to ERROR state" to be logged.
> > > > This happens when the QP is in IB_QPS_RESET state and the stack
> > > > is trying to transition it to IB_QPS_ERR state in
> > > > ipoib_ib_dev_stop().
> > > > 
> > > > According to the IB spec, Table 91 - "QP State Transition
> > > > Properties"
> > > > it looks like the transition from reset to error is valid:
> > > > 
> > > > Transition: Any State to Error
> > > > Required Attributes: None
> > > > Optional Attributes: None allowed
> > > > Actions: Queue processing is stopped. Work Requests pending or
> > > > in
> > > > process are completed in error, when possible.
> > > > 
> > > > This patch allows the transition and quiets the message.
> > > > 
> > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > > > >
> > > > ---
> > > 
> > > Thanks,
> > > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > Doug,
> > 
> > After digging more with Erez's help, it looks like the sentence "it
> > looks like the transition from reset to error is valid:" is not
> > correct.
> > 
> > According to the InfiniBandTM Architecture Release 1.3, Figure 126
> > QP/EE Context
> > State Diagram - transition to error from reset is not valid.
> > 
> > The quote from the spec:
> > "An error can be forced from any state, except Reset, with the
> > Modify QP/EE Verb."
> > 
> > I'll send revert patch along with proper fix.
> 
> Ahh, it wasn't pushed to kernel.org, so no need to revert and you can
> simply drop it.

It *is* on kernel.org, and has already been pulled by Linus:

commit ebc9ca43e1d52a85c72fc2d343f353386ed6c188
Author: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon May 29 17:20:53 2017 -0700

    IB/core: Allow QP state transition from reset to error
    
    Playing with IP-O-IB interface can trigger a warning message:
    "ib0: Failed to modify QP to ERROR state" to be logged.
    This happens when the QP is in IB_QPS_RESET state and the stack
    is trying to transition it to IB_QPS_ERR state in
ipoib_ib_dev_stop().
    
    According to the IB spec, Table 91 - "QP State Transition
Properties"
    it looks like the transition from reset to error is valid:
    
    Transition: Any State to Error
    Required Attributes: None
    Optional Attributes: None allowed
    Actions: Queue processing is stopped. Work Requests pending or in
    process are completed in error, when possible.
    
    This patch allows the transition and quiets the message.
    
    Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
