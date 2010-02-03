From: Viral Mehta <Viral.Mehta-oonXi/34qI7c+919tysfdA@public.gmane.org>
Subject: RE: data placement in-order guarantee ?
Date: Wed, 3 Feb 2010 09:43:51 +0530
Message-ID: <70376CA23424B34D86F1C7DE6B9973433D61963F@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <b681c62b1002020714s70c24fa7l4fcbf05617986b47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b681c62b1002020714s70c24fa7l4fcbf05617986b47-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mvapich discuss <mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
You can either do a "simple send" after RDMA write or you can also poll=
 on last byte... While I was working on it, I had done and I never ran =
into problem with either of the method.

Someone also quoted texts from Infiniband Spec, but I would also sugges=
t to read iWARP spec if you are going to support both of them.... For e=
xample, in case you decide to implement rdma_write_atomic then,
1. infiniband supports rdma_write_atomic and generates completion on bo=
th the sides..
2. iwarp does not support rdma_write_atomic and thus middle level libra=
ries (probably like udapl) will actually do rdma_write operation and wi=
ll generate completion on one side only...

Hope it may help :)

Thanks,
Viral

-----Original Message-----
=46rom: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of yogeshwar sonawane
Sent: Tuesday, February 02, 2010 8:44 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; mvapich discuss
Cc: yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: data placement in-order guarantee ?

Hi all,

=46ollowing question can be of na=EFve nature. Kindly, help me to clari=
fy
the points.
Thanks in Advance.

Consider an application on top of uverbs / udapl library and wants to
use only rdma write operations.
While using RDMA write operations, one has to indicate the responder
side(receiving side) somehow that the data transfer is complete. This
can be achieved simply by doing an extra rdma write (sort of control
write) conveying successful completion of DTO. Instead of this, can
programmer poll/check on the last data (int or byte) assuming in-order
placement of data in the receive buffer.
Can such behavior of last byte written last, assumed ? If application
programmer can rely on such behavior, then this asks for all networks
to guarantee such behavior.

It will be helpful if some information is shared as how mvapich2
handles the situation regarding above point (while using rdma
operations) ?

I thought that i should mail to both the mailing lists as topic covers
both domains.

Thanks and Regards,
Yogeshwar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

______________________________________________________________________

This Email may contain confidential or privileged information for the i=
ntended recipient (s) If you are not the intended recipient, please do =
not use or disseminate the information, notify the sender and delete it=
 from your system.

______________________________________________________________________
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
