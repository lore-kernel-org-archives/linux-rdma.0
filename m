From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [QUESTION] Is an ib_sbft kernel module needed to be made? (For
 booting using SRP)
Date: Tue, 19 Jul 2016 09:46:41 -0700
Message-ID: <685dba70-b94c-7646-6e4b-8ae93d4bd5d5@sandisk.com>
References: <CA+X5Wn4aYpxAKO5aCQS+T1MH1MMedd+ukBecZGSbg02QdX1YSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn4aYpxAKO5aCQS+T1MH1MMedd+ukBecZGSbg02QdX1YSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/18/2016 07:13 PM, james harvey wrote:
> I'm looking to boot using SRP.  I've spent a lot of time looking, and
> am not seeing that anyone has actually done this.  Really surprises
> me, actually.
>
> iPXE is able to make the SRP connection, load the kernel and
> initramfs, and leaves behind a SRP boot firmware table as described at
> http://ipxe.org/srp/sbft
>
> But, I don't see anything that finds, reads, or uses it.  So then then
> remote drive is no longer seen.
>
> I see iSCSI handles this problem through the kernel module iscsi_ibft
> which gives a sysfs interface to iSCSI's BFT structure.
>
> I'm somewhat interested in developing the ib_sbft kernel module, if
> I'm not missing an existing alternative to allow SRP booting.  I
> expect I could work from the iscsi_ibft kernel module source to be
> able to accomplish this, making the necessary changes based on the
> sBFT documentation and iPXE's sBFT-creating source.
>
> Is anyone else who has done kernel development interested in taking
> that on, or is it something I should start working on?
>
> If I had it working on my system, is there someone who would be
> willing to review/test/revise it to sign it to be pulled by Linus?

Hi James,

I'd be glad to help with testing and reviewing if you post an SRP 
equivalent of the iscsi_ibft kernel module.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
