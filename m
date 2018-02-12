From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 0/3] define Verbs flow steering specification filter for
 GRE and MPLSoGRE tunnels
Date: Mon, 12 Feb 2018 17:20:01 +0200
Message-ID: <CAFgAxU-VkaXqSpuhoWq0Xs=xq8SHLF2mnEACsPnjkSwWBdf+vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series intention is to allow verbs application to classify and
steer ingress packets of type GRE tunnels and MPLS-over-GRE tunnels to
a RAW PACKET QP.

The series defines the GRE header flow filter, the MPLS header flow
filter and a ibv_flow create flag to allow header ordering
structuring.

The classification filter ordering, allows the application to define a
very precise network header structure, this is a must for representing
many of the encapsulation tunnel protocols.
Specifically MPLS header can be placed over ETH, over IP, over GRE,
over UDP, so it does not fit into a specific header layer by
definition alone.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
