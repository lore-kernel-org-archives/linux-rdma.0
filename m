From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Wed, 6 May 2015 09:01:07 +0200
Message-ID: <5549BC33.30905@sandisk.com>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net>
 <20150505154411.GA16729@infradead.org>
 <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
 <20150505172540.GA19442@infradead.org> <55490886.4070502@talpey.com>
 <20150505191012.GA21164@infradead.org> <55492ED3.7000507@talpey.com>
 <20150505210627.GA5941@infradead.org> <554936E5.80607@talpey.com>
 <20150505223855.GA7696@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150505223855.GA7696-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/06/15 00:38, Jason Gunthorpe wrote:
> Heck, on modern systems 100% of these requirements can be solved just
> by using the IOMMU. No need for the HCA at all. (HCA may be more
> performant, of course)

Hello Jason,

Any performance tests I have run so far with the IOMMU enabled show much 
worse results than the same test with the IOMMU disabled. The perf tool 
learned me that this performance difference is due to lock contention 
caused by the IOMMU kernel code. I have not yet tried to verify whether 
this is an implementation issue or something fundamental.

This is why I'm not enthusiast about any approach that relies on the 
IOMMU being enabled.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
