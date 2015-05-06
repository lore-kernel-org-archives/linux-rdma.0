From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Wed, 6 May 2015 00:29:53 -0700
Message-ID: <20150506072953.GA32708@infradead.org>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net>
 <20150505154411.GA16729@infradead.org>
 <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
 <20150505172540.GA19442@infradead.org>
 <55490886.4070502@talpey.com>
 <20150505191012.GA21164@infradead.org>
 <55492ED3.7000507@talpey.com>
 <20150505210627.GA5941@infradead.org>
 <5549BE30.8020505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5549BE30.8020505-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 06, 2015 at 09:09:36AM +0200, Bart Van Assche wrote:
> On 05/05/15 23:06, Christoph Hellwig wrote:
> >The contiguous requirements isn't something we can alway guarantee.
> >While a lot of I/O will have that form the form where there are holes
> >can happen, although it's not common.
> 
> Indeed. That is why there is code in the SRP initiator that uses multiple
> FRWR registrations when a discontiguous SG-list is passed to that driver by
> the SCSI mid-layer. Some time ago I had posted a test program that makes the
> SCSI mid-layer submit a discontiguous I/O request to a SCSI LLD (see also
> https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg21224.html).

Note that block layer now has the (fairly misnamed) QUEUE_FLAG_SG_GAPS
flag, which ensures drivers don't see S/G lists like this one.  I
haven't ever seen normal TYPE_FS producers submit bios like that, so in
practice the effect is to reject vectored SG_IO uses like your test
program.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
