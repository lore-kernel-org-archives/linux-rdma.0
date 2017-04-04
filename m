From: Greg Rose <gvrose8192-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Infiniband Subnet Manager protocol specification
Date: Tue, 04 Apr 2017 12:06:46 -0700
Message-ID: <1491332806.30720.7.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Greetings all,

I am currently writing a Infiniband SW overlay driver for our RDMA
"like" network switches and HBA controllers.  I've gotten everything to
the point where I am getting SM 'get' requests that I know my
'process_mad' function is supposed to handle but I cannot for the life
of me find the protocol specification for Subnet Manager MAD packets.

I'm using opensm for the subnet manager and as of now it always reports
missing SM master.  I gather that is because I'm not handling the
packets that come in that need MAD processing correctly.

Googling for "Infiniband Subnet Manager protocol specification" is not
turning up anything useful.

If there is a better search term, or if there is a pointer to the
specification that someone can provide I'd be very grateful.

Thanks,

- Greg Rose


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
