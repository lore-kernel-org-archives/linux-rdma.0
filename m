From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures in
 the resource destroy path
Date: Fri, 15 May 2015 23:46:46 +0530
Message-ID: <5e802417a29f664cd23d9e0d32fc5984@mail.gmail.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
	 <1431762709-20740-11-git-send-email-selvin.xavier@avagotech.com> <1431705372.29187.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431705372.29187.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, May 15, 2015 9:26 PM
> To: Selvin Xavier
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures
> in the resource destroy path
>
> On Sat, 2015-05-16 at 13:21 +0530, Selvin Xavier wrote:
> > Avoid returning FW failures in the resource destroy verbs.
>
> This patch looks extremely unsafe to someone that doesn't have the benefit
> of being able to look at your firmware code.  What firmware errors are you
> ignoring?  What state is the card in whenever these errors are returned?
> Is
> there even a remote possibility that the firmware being in this state and
> returning these errors will either A) cause erroneous attempts to write to
> user memory or B) interfere with future attempts to create PDs or other
> contexts on the card?
>


One of the main reasons for these destroy commands to fail is when the
adapter is in  an unrecoverable error, which is handled in this patch.  Case
A will not be applicable in case of UE since adapter is down.   But Case A
is applicable if any rogue application passes wrong parameters like PDID for
destroy and the failure is a genuine error from FW .   I will rework on the
patch to handle these conditions also.

Case B is handled in both conditions. If the adapter is in UE, successive
create requests also will fail and failure is returned to the caller. If
adapter is in proper state,  successive create requests return success with
new resource IDs.

Thanks,
Selvin Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
