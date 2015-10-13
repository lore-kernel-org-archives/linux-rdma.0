From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.6 release
Date: Tue, 13 Oct 2015 00:11:33 -0400
Message-ID: <20151013041132.GA27824@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags at:

https://www.openfabrics.org/downloads/management/infiniband-diags-1.6.6=
=2Etar.gz

md5sum:

b855ca3b98afefc2ad6a2de378ab71dd  infiniband-diags-1.6.6.tar.gz


Dependencies:

        1) libibmad >=3D 1.3.12
        2) libibumad >=3D 1.3.7
        3) opensm-libs >=3D 3.3.10
        4) ib_umad kernel module
        5) glib2


Release notes v1.6.5 =3D> 1.6.6

   1) bug fixes


Authors since 1.6.5

Ana Guerrero L=F3pez (1):
      rdma-ndd: fix compiler warnings.

Dan Ben Yosef (2):
      perfquery -T (print Extended Speed Counters) times out on nodes s=
upporting
      libibnetdisc: Avoid pushing same pointer to the hash table

Hal Rosenstock (5):
      perfquery.c: Change format of capability mask in IBWARN for consi=
stency
      ibdiag_sa.c: In sa_get_handle, handle umad_open_port and umad_reg=
ister fai
      iblinkinfo.c: Close additional file descriptor in advance
      ibdiag_common.c: Move static to beginning of get_build_version de=
claration
      perfquery.c: Fix smp_query_via return value checks

Ira Weiny (3):
      infiniband-diags/rdma-ndd: Fix issues with install
      infiniband-diags/rdma-ndd: add --pidfile option
      infiniband-diags: rdma-ndd: remove udev logging when not supporte=
d

Michal Schmidt (2):
      rdma-ndd: never use udev_get_sys_path()
      build-sys: avoid overlinking to libudev

Vladimir Koushnir (10):
      ibqueryerrors: Resource leak in path_record_query
      Remove redundant umad file descriptor from libibnetdisc
      query_smp.c: Avoid busy looping in process_one_recv
      dump_fts: Open global file descriptor after calling ibnd_discover=
_fabric
      ibqueryerrors: code improvement
      ibqueryerrors: Fix crash when no SM is running
      ibqueryerrors: Close global file descriptor before running ibnd_d=
iscover_f
      ibqueryerrors: improve code related to DR option
      vendstat: mad_rpc_close_port not called in corner cases
      saquery.c: Fix saquery -D option


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
