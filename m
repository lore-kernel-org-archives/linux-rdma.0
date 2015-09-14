From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH] infiniband:Fix error checking in the function ocrdma_dereg_mr
Date: Mon, 14 Sep 2015 17:18:09 +0530
Message-ID: <CA+sbYW07nfm0nAN4kzjWsrR_fMcfQ2zQgHyU59qQwAer3rmxSA@mail.gmail.com>
References: <1441384543-32447-1-git-send-email-xerofoify@gmail.com>
	<55E9CAB2.3060106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E9CAB2.3060106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug/Jason/Nicholas,



Apologies for the delay in response.

I consulted with our f/w and h/w teams regarding this issue.  The current
ocrdma code seems right in handling the lkey dealloc failure from FW.
ocrdma_mbx_dealloc_lkey can fail only if f the FW is hung or PCI errors
( points 1 and 3 in Doug's mail).

Doug,
Please see inline  for replies to your specific queries


On Fri, Sep 4, 2015 at 10:15 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/04/2015 12:35 PM, Nicholas Krause wrote:
>> This fixes error checking in the function ocrdma_dereg_mr to properly
>> check if the call to ocrdma_mbx_alloc fails as if so we must exit this
>> function immediately and return the error code to the caller of the
>> function ocrdma_dereg_mr to signal a non recoverable error has occurred
>> when calling this function that needs to be handled by the caller in its
>> own intended error paths.
>
> This is probably not the right solution here.
>
> Emulex will need to speak to this as it involves firmware interactions.
>  But, in a nutshell, there are only a few very specific ways in which a
> mailbox command to a device should ever be expected to fail:
>
> 1) The device firmware is hung.  In which case we have bigger problems
> than the application can deal with and the driver needs to take its own
> actions, not leave it up to the calling kernel code or application.
>
> 2) The mr is still in active use.  I'm not even sure that this will
> cause a failure.  It depends on the firmware.  If the firmware knows it
> is still in use (by a queued work request) and fails to dereg the mr,
> then I could see returning that error code.  However, if the firmware
> simply does the dereg whether the mr is in use or not (presumably
> causing any work request still using this mr to fail once it finally
> attempts to use the mr), then there wouldn't be an error to return here.
>

FW will not fail  dealloc_lkey if the MRs are already in use.
Future work-requests will fail when it attempts to use this MR.
Hence driver is ignoring the return value ocrdma_mbx_dealloc_lkey.
So it is safe for the stack to free up the resources.
So i feel changes suggested by Nicholas is not necessary.

> 3) Unspecified PCI error resulting in an inability to communicate with
> the card at all.  This falls under the same category as #1 and is beyond
> the scope of a calling application.
>
> So, depending on Emulex's answer in regards to #2 above, I doubt this
> patch is the right thing to do.  For #1 and #3, the card will certainly
> have to be reset before it can be used again, and will loose all of its
> registrations anyway, so we would need to *not* return from an error
> condition and we would need to proceed to clean up all of the dangling
> resources and then return a 0 result as the application should not be
> involved in the recovery that must take place.
>

PCI error and FW hang needs to be handled as mentioned above by Doug.
As of now reboot is the only solution, for this very rare scenario. Is there any
support from the stack framework to cleanup kernel and application resources,
as this error path will be common for all other vendor drivers?

Thanks,
Selvin Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
