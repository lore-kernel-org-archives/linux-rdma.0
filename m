From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Remote access to pmem on storage targets
Date: Tue, 26 Jan 2016 09:00:21 -0800
Message-ID: <20160126170021.GA21672@infradead.org>
References: <06414D5A-0632-4C74-B76C-038093E8AED3@oracle.com>
 <5FD20017-B588-42E6-BBDA-2AA8ABDBA42B@ornl.gov>
 <D0C5C0B9-A1A2-4428-B3CA-7BBCC5BEF10D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D0C5C0B9-A1A2-4428-B3CA-7BBCC5BEF10D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, "lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 26, 2016 at 10:29:35AM -0500, Chuck Lever wrote:
> As I understand it, NVMf devices look like local devices.
> NVMf devices need globally unique naming to enable safe use
> with pNFS and other remote storage access protocols.

NVMe provides global uniqueue identifiers similar to SCSI, and in fact
there is even a standardised mapping to SCSI.  The current SCSI layout
draft will work fine with both multi ported PCIe NVMe devices as well
as future fabrics devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
