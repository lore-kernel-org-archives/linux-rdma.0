From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Wed, 18 Jul 2018 14:29:14 -0500
Message-ID: <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
References: <20180716083012.15410-1-leon@kernel.org> <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me> <20180716103046.GJ3152@mtr-leonro.mtl.com> <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com> <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me> <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com> <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com> <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com> <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com> <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me> <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_02DD_01D41EA3.B3F298B0"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Max Gurtovoy' <maxg@mellanox.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_02DD_01D41EA3.B3F298B0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


>=20
> On 7/18/2018 2:38 PM, Sagi Grimberg wrote:
> >
> >>> IMO we must fulfil the user wish to connect to N queues and not =
reduce
> >>> it because of affinity overlaps. So in order to push Leon's patch =
we
> >>> must also fix the blk_mq_rdma_map_queues to do a best effort
> mapping
> >>> according the affinity and map the rest in naive way (in that way =
we
> >>> will *always* map all the queues).
> >>
> >> That is what I would expect also.   For example, in my node, where
> >> there are
> >> 16 cpus, and 2 numa nodes, I observe much better nvmf IOPS
> performance by
> >> setting up my 16 driver completion event queues such that each is
> >> bound to a
> >> node-local cpu.  So I end up with each nodel-local cpu having 2 =
queues
> >> bound
> >> to it.   W/O adding support in iw_cxgb4 for =
ib_get_vector_affinity(),
> >> this
> >> works fine.   I assumed adding ib_get_vector_affinity() would allow
> >> this to
> >> all "just work" by default, but I'm running into this connection =
failure
> >> issue.
> >>
> >> I don't understand exactly what the blk_mq layer is trying to do, =
but I
> >> assume it has ingress event queues and processing that it trying to =
align
> >> with the drivers ingress cq event handling, so everybody stays on =
the
> >> same
> >> cpu (or at least node).   But something else is going on.  Is there
> >> documentation on how this works somewhere?
> >
> > Does this (untested) patch help?
>=20
> I'm not sure (I'll test it tomorrow) because the issue is the unmapped
> queues and not the cpus.
> for example, if the affinity of q=3D6 and q=3D12 returned the same =
cpumask
> than q=3D6 will not be mapped and will fail to connect.
>

Attached is a patch that applies cleanly for me.  It has problems if =
vectors have affinity to more than 1 cpu:

[ 2031.988881] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
[ 2031.994706] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
[ 2032.000348] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
[ 2032.005992] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
[ 2032.011629] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
[ 2032.017271] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
[ 2032.022901] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
[ 2032.028514] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
[ 2032.034110] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
[ 2032.039677] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
[ 2032.045244] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
[ 2032.050889] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
[ 2032.056531] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
[ 2032.062174] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
[ 2032.067817] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
[ 2032.073457] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
[ 2032.079102] blk_mq_rdma_map_queues: set->mq_map[0] queue 0 vector 0
[ 2032.085621] blk_mq_rdma_map_queues: set->mq_map[1] queue 1 vector 1
[ 2032.092139] blk_mq_rdma_map_queues: set->mq_map[2] queue 2 vector 2
[ 2032.098658] blk_mq_rdma_map_queues: set->mq_map[3] queue 3 vector 3
[ 2032.105177] blk_mq_rdma_map_queues: set->mq_map[4] queue 4 vector 4
[ 2032.111689] blk_mq_rdma_map_queues: set->mq_map[5] queue 5 vector 5
[ 2032.118208] blk_mq_rdma_map_queues: set->mq_map[6] queue 6 vector 6
[ 2032.124728] blk_mq_rdma_map_queues: set->mq_map[7] queue 7 vector 7
[ 2032.131246] blk_mq_rdma_map_queues: set->mq_map[8] queue 15 vector 15
[ 2032.137938] blk_mq_rdma_map_queues: set->mq_map[9] queue 15 vector 15
[ 2032.144629] blk_mq_rdma_map_queues: set->mq_map[10] queue 15 vector =
15
[ 2032.151401] blk_mq_rdma_map_queues: set->mq_map[11] queue 15 vector =
15
[ 2032.158172] blk_mq_rdma_map_queues: set->mq_map[12] queue 15 vector =
15
[ 2032.164940] blk_mq_rdma_map_queues: set->mq_map[13] queue 15 vector =
15
[ 2032.171709] blk_mq_rdma_map_queues: set->mq_map[14] queue 15 vector =
15
[ 2032.178477] blk_mq_rdma_map_queues: set->mq_map[15] queue 15 vector =
15
[ 2032.187409] nvme nvme0: Connect command failed, error wo/DNR bit: =
-16402
[ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=3D-18
=20
But if I set all my vector affinities single cpus but only those in the =
same numa node, it now works:

[ 2311.884397] iw_cxgb4: comp_vector 0, irq 203 mask 0x100
[ 2311.890103] iw_cxgb4: comp_vector 1, irq 204 mask 0x200
[ 2311.895659] iw_cxgb4: comp_vector 2, irq 205 mask 0x400
[ 2311.901211] iw_cxgb4: comp_vector 3, irq 206 mask 0x800
[ 2311.906758] iw_cxgb4: comp_vector 4, irq 207 mask 0x1000
[ 2311.912390] iw_cxgb4: comp_vector 5, irq 208 mask 0x2000
[ 2311.918014] iw_cxgb4: comp_vector 6, irq 209 mask 0x4000
[ 2311.923627] iw_cxgb4: comp_vector 7, irq 210 mask 0x8000
[ 2311.929213] iw_cxgb4: comp_vector 8, irq 211 mask 0x100
[ 2311.934694] iw_cxgb4: comp_vector 9, irq 212 mask 0x200
[ 2311.940163] iw_cxgb4: comp_vector 10, irq 213 mask 0x400
[ 2311.945716] iw_cxgb4: comp_vector 11, irq 214 mask 0x800
[ 2311.951272] iw_cxgb4: comp_vector 12, irq 215 mask 0x1000
[ 2311.956914] iw_cxgb4: comp_vector 13, irq 216 mask 0x2000
[ 2311.962558] iw_cxgb4: comp_vector 14, irq 217 mask 0x4000
[ 2311.968201] iw_cxgb4: comp_vector 15, irq 218 mask 0x8000
[ 2311.973845] blk_mq_rdma_map_queues: set->mq_map[0] queue 0 vector 0
[ 2311.980367] blk_mq_rdma_map_queues: set->mq_map[1] queue 1 vector 1
[ 2311.986885] blk_mq_rdma_map_queues: set->mq_map[2] queue 2 vector 2
[ 2311.993402] blk_mq_rdma_map_queues: set->mq_map[3] queue 3 vector 3
[ 2311.999919] blk_mq_rdma_map_queues: set->mq_map[4] queue 4 vector 4
[ 2312.006436] blk_mq_rdma_map_queues: set->mq_map[5] queue 5 vector 5
[ 2312.012956] blk_mq_rdma_map_queues: set->mq_map[6] queue 6 vector 6
[ 2312.019473] blk_mq_rdma_map_queues: set->mq_map[7] queue 7 vector 7
[ 2312.025991] blk_mq_rdma_map_queues: set->mq_map[8] queue 8 vector 8
[ 2312.032511] blk_mq_rdma_map_queues: set->mq_map[9] queue 9 vector 9
[ 2312.039030] blk_mq_rdma_map_queues: set->mq_map[10] queue 10 vector =
10
[ 2312.045801] blk_mq_rdma_map_queues: set->mq_map[11] queue 11 vector =
11
[ 2312.052572] blk_mq_rdma_map_queues: set->mq_map[12] queue 12 vector =
12
[ 2312.059341] blk_mq_rdma_map_queues: set->mq_map[13] queue 13 vector =
13
[ 2312.066111] blk_mq_rdma_map_queues: set->mq_map[14] queue 14 vector =
14
[ 2312.072879] blk_mq_rdma_map_queues: set->mq_map[15] queue 15 vector =
15
[ 2312.081926] nvme nvme0: new ctrl: NQN "nvme-nullb0", addr =
172.16.2.1:4420


------=_NextPart_000_02DD_01D41EA3.B3F298B0
Content-Type: application/octet-stream;
	name="sagi2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="sagi2.patch"

commit 5128aa16a366c78aaa7a96f3e5760f993e9edb3e=0A=
Author: Steve Wise <swise@opengridcomputing.com>=0A=
Date:   Wed Jul 18 06:53:32 2018 -0700=0A=
=0A=
    sagi's patch2=0A=
=0A=
diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c=0A=
index 3eb169f15842..02b888ff3c10 100644=0A=
--- a/block/blk-mq-cpumap.c=0A=
+++ b/block/blk-mq-cpumap.c=0A=
@@ -30,29 +30,36 @@ static int get_first_sibling(unsigned int cpu)=0A=
 	return cpu;=0A=
 }=0A=
 =0A=
-int blk_mq_map_queues(struct blk_mq_tag_set *set)=0A=
+void blk_mq_map_queue_to_cpu(struct blk_mq_tag_set *set, unsigned int =
cpu)=0A=
 {=0A=
 	unsigned int *map =3D set->mq_map;=0A=
 	unsigned int nr_queues =3D set->nr_hw_queues;=0A=
-	unsigned int cpu, first_sibling;=0A=
+	unsigned int first_sibling;=0A=
 =0A=
-	for_each_possible_cpu(cpu) {=0A=
-		/*=0A=
-		 * First do sequential mapping between CPUs and queues.=0A=
-		 * In case we still have CPUs to map, and we have some number of=0A=
-		 * threads per cores then map sibling threads to the same queue for=0A=
-		 * performace optimizations.=0A=
-		 */=0A=
-		if (cpu < nr_queues) {=0A=
+	/*=0A=
+	 * First do sequential mapping between CPUs and queues.=0A=
+	 * In case we still have CPUs to map, and we have some number of=0A=
+	 * threads per cores then map sibling threads to the same queue for=0A=
+	 * performace optimizations.=0A=
+	 */=0A=
+	if (cpu < nr_queues) {=0A=
+		map[cpu] =3D cpu_to_queue_index(nr_queues, cpu);=0A=
+	} else {=0A=
+		first_sibling =3D get_first_sibling(cpu);=0A=
+		if (first_sibling =3D=3D cpu)=0A=
 			map[cpu] =3D cpu_to_queue_index(nr_queues, cpu);=0A=
-		} else {=0A=
-			first_sibling =3D get_first_sibling(cpu);=0A=
-			if (first_sibling =3D=3D cpu)=0A=
-				map[cpu] =3D cpu_to_queue_index(nr_queues, cpu);=0A=
-			else=0A=
-				map[cpu] =3D map[first_sibling];=0A=
-		}=0A=
+		else=0A=
+			map[cpu] =3D map[first_sibling];=0A=
 	}=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(blk_mq_map_queue_to_cpu);=0A=
+=0A=
+int blk_mq_map_queues(struct blk_mq_tag_set *set)=0A=
+{=0A=
+	unsigned int cpu;=0A=
+=0A=
+	for_each_possible_cpu(cpu)=0A=
+		blk_mq_map_queue_to_cpu(set, cpu);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c=0A=
index 996167f1de18..27210105a882 100644=0A=
--- a/block/blk-mq-rdma.c=0A=
+++ b/block/blk-mq-rdma.c=0A=
@@ -35,6 +35,10 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,=0A=
 	const struct cpumask *mask;=0A=
 	unsigned int queue, cpu;=0A=
 =0A=
+	/* reset all to  */=0A=
+	for_each_possible_cpu(cpu)=0A=
+		set->mq_map[cpu] =3D UINT_MAX;=0A=
+=0A=
 	for (queue =3D 0; queue < set->nr_hw_queues; queue++) {=0A=
 		mask =3D ib_get_vector_affinity(dev, first_vec + queue);=0A=
 		if (!mask)=0A=
@@ -44,6 +48,11 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,=0A=
 			set->mq_map[cpu] =3D queue;=0A=
 	}=0A=
 =0A=
+	for_each_possible_cpu(cpu) {=0A=
+		if (set->mq_map[cpu] =3D=3D UINT_MAX)=0A=
+			blk_mq_map_queue_to_cpu(set, cpu);=0A=
+	}=0A=
+=0A=
 	return 0;=0A=
 =0A=
 fallback:=0A=
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h=0A=
index e3147eb74222..19e83d93a1d4 100644=0A=
--- a/include/linux/blk-mq.h=0A=
+++ b/include/linux/blk-mq.h=0A=
@@ -283,6 +283,7 @@ int blk_mq_freeze_queue_wait_timeout(struct =
request_queue *q,=0A=
 				     unsigned long timeout);=0A=
 =0A=
 int blk_mq_map_queues(struct blk_mq_tag_set *set);=0A=
+void blk_mq_map_queue_to_cpu(struct blk_mq_tag_set *set, unsigned int =
cpu);=0A=
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int =
nr_hw_queues);=0A=
 =0A=
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);=0A=

------=_NextPart_000_02DD_01D41EA3.B3F298B0--
