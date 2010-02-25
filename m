From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: The SRP initiator and the endianness of tags in SRP information units
Date: Thu, 25 Feb 2010 13:04:33 -0800
Message-ID: <adatyt5vxge.fsf@roland-alpha.cisco.com>
References: <e2e108261001020350h2a63377v153ff5dc7c1519b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001020350h2a63377v153ff5dc7c1519b5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sat, 2 Jan 2010 12:50:56 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I have a question about the SRP initiator available in the Linux
 > kernel. While consulting the SRP spec (r16a) I noticed that all
 > multi-byte integer fields of SRP information units must be sent using
 > the big endian byte order. This holds e.g. for the 64-bit tag fields
 > present in several information units. So I was expecting these tags to
 > be declared as __be64. However, in the header file <scsi/srp.h> these
 > tags are declared as type u64, that is, being stored in CPU order. As
 > a result, the byte order of the tags sent by the SRP initiator will
 > depend on the endianness of the CPU the SRP initiator is running on
 > (e.g. little endian on Intel CPU's, big endian on PowerPC CPU's).
 > While this doesn't harm -- an SRP target must send back the same tag
 > it received -- I found this confusing. Is this the intended behavior
 > of the SRP initiator ?

Didn't reply before... sorry.

Anyway my view is that since tags are just an opaque 64-bit quantity, it
doesn't really make sense to worry about endianness.  You wouldn't
byte-swap a field that was an 8-byte string, and the tag is essentially
the same thing.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
