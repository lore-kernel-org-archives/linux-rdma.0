From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.2-1 release
Date: Tue, 2 Sep 2014 22:16:11 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E6F741@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.2) is available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 3.12-1 RC2

md5sum: dd757dec11cb23702aea8474e76a0037 dapl-2.1.2.tar.gz

For v2.1 package install RPM packages as follow:

 dapl-2.1.2-1
 dapl-utils-2.1.2-1
 dapl-devel-2.1.2-1
 dapl-debuginfo-2.1.2-1

Summary of changes:

Release 2.1.2 
mpxyd: add global routing support for proxy connections
mcm: only call mix_get_attr if running on MIC
openib: modify check for link_layer to handle unspecified
dapl: add support for the s390x platform
dtest server exchange connection info with client
mpxyd: 2 MICs in same numa_node will overlap CPU affinity, don't reset base
mcm: implement proxy mix_prov_attr function, add fields CPU model and family
mpxyd: tx thread may not be signaled on small segment writes

Release commit:  http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=25568900892f9e72413e235ebc4ba77176343c84

Regards,

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
