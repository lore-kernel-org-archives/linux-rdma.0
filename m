From: yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: data placement in-order guarantee ?
Date: Tue, 2 Feb 2010 20:44:23 +0530
Message-ID: <b681c62b1002020714s70c24fa7l4fcbf05617986b47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mvapich discuss <mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Cc: yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
