From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibmad 1.3.12 release
Date: Wed, 11 Feb 2015 00:04:47 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC23C16@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of libibmad available at:

https://www.openfabrics.org/downloads/management/

md5sum:
7aabf50569c4d30a9a0689fd96097e4f  libibmad-1.3.12.tar.gz

Dependencies:

        1) libibumad >= 1.3.7
        2) opensm-libs >= 3.3.10
        3) ib_umad kernel module

Release notes for 1.3.11 to 1.3.12 are:

   1) bug fixes
   2) new Fields for Port Extended Speeds


Updates since 1.3.11


  Hal Rosenstock  :  fields.c: Fix commentary typo
  Al Chu  :  libibmad/src/rpc.c: Remove superfluous packet dump
  Hal Rosenstock  :  fields.c: Print SwitchCongestionSetting threshold fields in hex rather than decimal
  Dan Ben Yosef  :  libibmad: Add new fields for SM:PortInfoExtended and for PM:PortExtendedSpeedsCounters
  Hal Rosenstock  :  dump.c: In mad_dump_linkwidth, output undefined widths

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
