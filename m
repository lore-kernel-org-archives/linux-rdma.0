From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibmad 1.3.10 release
Date: Sun, 18 Aug 2013 07:44:25 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E022343FA@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of libibmad.
Tarball available in:

http://www.openfabrics.org/downloads/management/
       
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
2df6e87a707801b05c51d0c25872d69b  libibmad-1.3.10.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Author: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

    Update README and version to 1.3.10 release
    libibmad: update emails

Author: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

    libibmad: Add setting of errno on function failure
    libibmad: mask off the kernel transaction id bits
    libibmad: To handle null dev_name in madrpc_init
    libibmad: Conversion specifier; %m is not supported on Solaris
    libibmad: To fix compilation warning: need typecasts

Author: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

    libibmad: Add support for PortSamplesResult
    libibmad: Add NodeRecord query API
    libibmad/dump.c: In mad_dump_mtu, don't set buf[0] to 0

Author: Huang, Perry <huang32-i2BcT+NCU+M@public.gmane.org>

    libibmad: Add comment notes for various PortSelect and CounterSelect fields.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
