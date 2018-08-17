From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Fri, 17 Aug 2018 11:17:38 -0500
Message-ID: <000001d43645$d0fdbc00$72f93400$@opengridcomputing.com>
References: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com> <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com> <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com> <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com> <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me> <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com> <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com> <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com> <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com> <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com> <20180723164910.GS31540@mellanox.com> <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com> <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me> <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com> <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomp
 uting.com> <4a13541c-db48-beca-4ee7-932528b22986@grimberg.me> <85bba372-049c-2a12-362e-adcb0931cf49@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <85bba372-049c-2a12-362e-adcb0931cf49@opengridcomputing.com>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Jason Gunthorpe' <jgg@mellanox.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> On 8/16/2018 1:26 PM, Sagi Grimberg wrote:
> >
> >> Let me know if you want me to try this or any particular fix.
> >
> > Steve, can you test this one?
> 
> Yes!  I'll try it out tomorrow.
> 
> Stevo
> 

Hey Sagi,

The patch works allowing connections for the various affinity mappings below:

One comp_vector per core across all cores, starting with numa-local cores:

[ 3798.494963] iw_cxgb4: comp_vector 0, irq 203 mask 0x100
[ 3798.500717] iw_cxgb4: comp_vector 1, irq 204 mask 0x200
[ 3798.506396] iw_cxgb4: comp_vector 2, irq 205 mask 0x400
[ 3798.512043] iw_cxgb4: comp_vector 3, irq 206 mask 0x800
[ 3798.517675] iw_cxgb4: comp_vector 4, irq 207 mask 0x1000
[ 3798.523382] iw_cxgb4: comp_vector 5, irq 208 mask 0x2000
[ 3798.529075] iw_cxgb4: comp_vector 6, irq 209 mask 0x4000
[ 3798.534754] iw_cxgb4: comp_vector 7, irq 210 mask 0x8000
[ 3798.540425] iw_cxgb4: comp_vector 8, irq 211 mask 0x1
[ 3798.545825] iw_cxgb4: comp_vector 9, irq 212 mask 0x2
[ 3798.551231] iw_cxgb4: comp_vector 10, irq 213 mask 0x4
[ 3798.556713] iw_cxgb4: comp_vector 11, irq 214 mask 0x8
[ 3798.562189] iw_cxgb4: comp_vector 12, irq 215 mask 0x10
[ 3798.567755] iw_cxgb4: comp_vector 13, irq 216 mask 0x20
[ 3798.573312] iw_cxgb4: comp_vector 14, irq 217 mask 0x40
[ 3798.578855] iw_cxgb4: comp_vector 15, irq 218 mask 0x80
[ 3798.584384] set->mq_map[0] queue 8 vector 8
[ 3798.588879] set->mq_map[1] queue 9 vector 9
[ 3798.593358] set->mq_map[2] queue 10 vector 10
[ 3798.598008] set->mq_map[3] queue 11 vector 11
[ 3798.602633] set->mq_map[4] queue 12 vector 12
[ 3798.607260] set->mq_map[5] queue 13 vector 13
[ 3798.611872] set->mq_map[6] queue 14 vector 14
[ 3798.616470] set->mq_map[7] queue 15 vector 15
[ 3798.621059] set->mq_map[8] queue 0 vector 0
[ 3798.625460] set->mq_map[9] queue 1 vector 1
[ 3798.629852] set->mq_map[10] queue 2 vector 2
[ 3798.634331] set->mq_map[11] queue 3 vector 3
[ 3798.638796] set->mq_map[12] queue 4 vector 4
[ 3798.643263] set->mq_map[13] queue 5 vector 5
[ 3798.647727] set->mq_map[14] queue 6 vector 6
[ 3798.652197] set->mq_map[15] queue 7 vector 7

One comp_vector per core, but only numa-local cores:

[ 3855.406027] iw_cxgb4: comp_vector 0, irq 203 mask 0x400
[ 3855.411577] iw_cxgb4: comp_vector 1, irq 204 mask 0x800
[ 3855.417057] iw_cxgb4: comp_vector 2, irq 205 mask 0x1000
[ 3855.422618] iw_cxgb4: comp_vector 3, irq 206 mask 0x2000
[ 3855.428176] iw_cxgb4: comp_vector 4, irq 207 mask 0x4000
[ 3855.433731] iw_cxgb4: comp_vector 5, irq 208 mask 0x8000
[ 3855.439293] iw_cxgb4: comp_vector 6, irq 209 mask 0x100
[ 3855.444770] iw_cxgb4: comp_vector 7, irq 210 mask 0x200
[ 3855.450231] iw_cxgb4: comp_vector 8, irq 211 mask 0x400
[ 3855.455691] iw_cxgb4: comp_vector 9, irq 212 mask 0x800
[ 3855.461144] iw_cxgb4: comp_vector 10, irq 213 mask 0x1000
[ 3855.466768] iw_cxgb4: comp_vector 11, irq 214 mask 0x2000
[ 3855.472379] iw_cxgb4: comp_vector 12, irq 215 mask 0x4000
[ 3855.477992] iw_cxgb4: comp_vector 13, irq 216 mask 0x8000
[ 3855.483599] iw_cxgb4: comp_vector 14, irq 217 mask 0x100
[ 3855.489116] iw_cxgb4: comp_vector 15, irq 218 mask 0x200
[ 3855.494644] set->mq_map[0] queue 8 vector 8
[ 3855.499046] set->mq_map[1] queue 9 vector 9
[ 3855.503445] set->mq_map[2] queue 10 vector 10
[ 3855.508025] set->mq_map[3] queue 11 vector 11
[ 3855.512600] set->mq_map[4] queue 12 vector 12
[ 3855.517176] set->mq_map[5] queue 13 vector 13
[ 3855.521750] set->mq_map[6] queue 14 vector 14
[ 3855.526325] set->mq_map[7] queue 15 vector 15
[ 3855.530902] set->mq_map[8] queue 6 vector 6
[ 3855.535306] set->mq_map[9] queue 7 vector 7
[ 3855.539703] set->mq_map[10] queue 0 vector 0
[ 3855.544197] set->mq_map[11] queue 1 vector 1
[ 3855.548670] set->mq_map[12] queue 2 vector 2
[ 3855.553144] set->mq_map[13] queue 3 vector 3
[ 3855.557630] set->mq_map[14] queue 4 vector 4
[ 3855.562105] set->mq_map[15] queue 5 vector 5

Each comp_vector has affinity to all numa-local cores:

[ 4010.002954] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
[ 4010.008606] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
[ 4010.014179] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
[ 4010.019741] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
[ 4010.025310] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
[ 4010.030881] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
[ 4010.036448] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
[ 4010.042012] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
[ 4010.047562] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
[ 4010.053103] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
[ 4010.058632] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
[ 4010.064248] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
[ 4010.069863] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
[ 4010.075462] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
[ 4010.081066] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
[ 4010.086676] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
[ 4010.092283] set->mq_map[0] queue 8 vector 8
[ 4010.096683] set->mq_map[1] queue 9 vector 9
[ 4010.101085] set->mq_map[2] queue 10 vector 10
[ 4010.105663] set->mq_map[3] queue 11 vector 11
[ 4010.110239] set->mq_map[4] queue 12 vector 12
[ 4010.114810] set->mq_map[5] queue 13 vector 13
[ 4010.119379] set->mq_map[6] queue 14 vector 14
[ 4010.123942] set->mq_map[7] queue 15 vector 15
[ 4010.128502] set->mq_map[8] queue 0 vector 0
[ 4010.132903] set->mq_map[9] queue 1 vector 1
[ 4010.137299] set->mq_map[10] queue 2 vector 2
[ 4010.141792] set->mq_map[11] queue 3 vector 3
[ 4010.146274] set->mq_map[12] queue 4 vector 4
[ 4010.150754] set->mq_map[13] queue 5 vector 5
[ 4010.155235] set->mq_map[14] queue 6 vector 6
[ 4010.159716] set->mq_map[15] queue 7 vector 7
