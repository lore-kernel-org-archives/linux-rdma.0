From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Sun, 15 Nov 2015 11:48:08 -0800
Message-ID: <5648E178.9010106@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <20151115180621.GA24488@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151115180621.GA24488-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/15/15 10:06, Christoph Hellwig wrote:
> FYI, I sent a patch for the zero S/G length issue.  With this xfstests
> does fine for ext4 and btrfs.  With XFS I still run into corruption
> warnings for the slab use after free poison pattern.  I suspect that
> issue might be related to uniqueue XFS I/O patterns.  One thing that
> might be related is that XFS can submit bios backed by kmalloced memory.
>
> I've also tested XFS on various other storage devices on the same kernel
> and didn't see an issue like that just to be sure.

Thanks for submitting that patch.

Did I understand correctly that page-aligned I/O works fine but I/O that 
is not aligned on a page boundary not ? Have you already had the time to 
verify whether the "IB/srp: Convert to new registration API" patch is 
the patch that introduced this issue ?

BTW, another location where a buffer is used that is not aligned on a 
page boundary is the scsi_probe_and_add_lun() function. If a crash 
occurs while probing LUNs or lsscsi shows garbled data for SRP LUNs that 
might indicate a problem in the buffer mapping or registration code.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
