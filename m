From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: The SRP initiator and the endianness of tags in SRP information units
Date: Sat, 2 Jan 2010 12:50:56 +0100
Message-ID: <e2e108261001020350h2a63377v153ff5dc7c1519b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Roland,

First of all, my best wishes for the new year. I hope that you will be
able to continue supporting the RDMA community in 2010.

I have a question about the SRP initiator available in the Linux
kernel. While consulting the SRP spec (r16a) I noticed that all
multi-byte integer fields of SRP information units must be sent using
the big endian byte order. This holds e.g. for the 64-bit tag fields
present in several information units. So I was expecting these tags to
be declared as __be64. However, in the header file <scsi/srp.h> these
tags are declared as type u64, that is, being stored in CPU order. As
a result, the byte order of the tags sent by the SRP initiator will
depend on the endianness of the CPU the SRP initiator is running on
(e.g. little endian on Intel CPU's, big endian on PowerPC CPU's).
While this doesn't harm -- an SRP target must send back the same tag
it received -- I found this confusing. Is this the intended behavior
of the SRP initiator ?

The different tag fields declared in <scsi/srp.h> are:

$ grep -n '64.*tag;' include/scsi/srp.h
121:    u64     tag;
140:    u64     tag;
152:    u64     tag;
161:    u64     tag;
169:    u64     tag;
180:    u64     tag;
186:    u64     task_tag;
201:    u64     tag;
231:    u64     tag;
251:    u64     tag;
261:    u64     tag;

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
