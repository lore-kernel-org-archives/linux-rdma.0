From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 13:28:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1406091326430.9663@gentwo.org>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com> <20140609165105.GB1816@obsidianresearch.com> <alpine.DEB.2.10.1406091307230.9663@gentwo.org>
 <004701cf840e$90e1cf00$b2a56d00$@opengridcomputing.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004701cf840e$90e1cf00$b2a56d00$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 9 Jun 2014, Steve Wise wrote:

> I don't see how the flow steering API does anything like the port mapping.

You can redirect flows with a particular port number. Thats the same as
port mappig right?

linux/include/rdma/ib_verbs.h:

struct ib_flow_spec_ipv4 {
        enum ib_flow_spec_type     type;
        u16                        size;
        struct ib_flow_ipv4_filter val;
        struct ib_flow_ipv4_filter mask;
};

struct ib_flow_tcp_udp_filter {
        __be16  dst_port;
        __be16  src_port;
};

struct ib_flow_spec_tcp_udp {
        enum ib_flow_spec_type        type;
        u16                           size;
        struct ib_flow_tcp_udp_filter val;
        struct ib_flow_tcp_udp_filter mask;
};

union ib_flow_spec {
        struct {
                enum ib_flow_spec_type  type;
                u16                     size;
        };
        struct ib_flow_spec_eth         eth;
        struct ib_flow_spec_ib          ib;
        struct ib_flow_spec_ipv4        ipv4;
        struct ib_flow_spec_tcp_udp     tcp_udp;
};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
