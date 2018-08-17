From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Fri, 17 Aug 2018 16:28:17 -0500
Message-ID: <275501d43671$36eaaa20$a4bffe60$@opengridcomputing.com>
References: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com> <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com> <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com> <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com> <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me> <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com> <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com> <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com> <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com> <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com> <20180723164910.GS31540@mellanox.com> <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com> <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me> <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com> <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomp
 uting.com> <4a13541c-db48-beca-4ee7-932528b22986@grimberg.me> <85bba372-049c-2a12-362e-adcb0931cf49@opengridcomputing.com> <000001d43645$d0fdbc00$72f93400$@opengridcomputing.com> <ed1ea546-e
 7aa-3c17-710b-8c95fe90
        deea@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ed1ea546-e7aa-3c17-710b-8c95fe90deea@grimberg.me>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Jason Gunthorpe' <jgg@mellanox.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > Hey Sagi,
> >
> > The patch works allowing connections for the various affinity mappings
> below:
> >
> > One comp_vector per core across all cores, starting with numa-local cores:
> 
> Thanks Steve, is this your "Tested by:" tag?

Sure:

Tested-by: Steve Wise <swise@opengridcomputing.com>
