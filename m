From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 15:52:01 -0400
Message-ID: <F90894CF-B55C-4AF7-845C-279FDF44351E@ornl.gov>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com>
 <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov>
 <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000@email.amazonses.com>
 <78D8717C-0505-408B-8625-A9124AB33C9E@ornl.gov>
 <0000013997da4014-44dda0e8-01f3-48b8-b0cd-fe41164d590c-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013997da4014-44dda0e8-01f3-48b8-b0cd-fe41164d590c-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Sep 5, 2012, at 3:13 PM, Christoph Lameter wrote:

> On Wed, 5 Sep 2012, Atchley, Scott wrote:
> 
>> These are Mellanox QDR HCAs (board id is MT_0D90110009). The full output of ibv_devinfo is in my original post.
> 
> Hmmm... You are running an old kernel. What version of OFED do you use?

Hah, if you think my kernel is old, you should see my userland (RHEL5.5). ;-)

Does the version of OFED impact the kernel modules? I am using the modules that came with the kernel. I don't believe that libibverbs or librdmacm are used by the kernel's socket stack. That said, I am using source builds with tags libibverbs-1.1.6 and v1.0.16 (librdmacm).

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
