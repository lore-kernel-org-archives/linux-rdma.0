From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: rdma-core ec54a28 fails to build (missing PVRDMA_UAR_SRQ_OFFSET) on
 Ubuntu >= 17.04
Date: Tue, 14 Nov 2017 11:20:14 +0100
Message-ID: <1510654814.4026.15.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

the daily builds failed today for Ubuntu >= 17.04 on all architectures:

/usr/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude
-I/usr/include/libnl3 -g -O2 -fdebug-prefix-map=/<<PKGBUILDDIR>>=.
-fstack-protector-strong -Wformat -Werror=format-security -Wdate-time
-D_FORTIFY_SOURCE=2 -Wall -Wextra -Wno-sign-compare -Wno-unused-
parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings
-Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition
-Wredundant-decls -O2 -g -DNDEBUG -fPIC   -std=gnu11 -MD -MT
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o -MF
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o.d -o
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o   -c
../providers/vmw_pvrdma/cq.c
In file included from ../providers/vmw_pvrdma/cq.c:48:0:
../providers/vmw_pvrdma/pvrdma.h: In function ‘pvrdma_write_uar_srq’:
../providers/vmw_pvrdma/pvrdma.h:244:20: error: ‘PVRDMA_UAR_SRQ_OFFSET’
undeclared (first use in this function); did you mean
‘PVRDMA_UAR_CQ_OFFSET’?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) = htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
../providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared
identifier is reported only once for each function it appears in
[100/190] /usr/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude
-I/usr/include/libnl3 -g -O2 -fdebug-prefix-map=/<<PKGBUILDDIR>>=.
-fstack-protector-strong -Wformat -Werror=format-security -Wdate-time
-D_FORTIFY_SOURCE=2 -Wall -Wextra -Wno-sign-compare -Wno-unused-
parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings
-Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition
-Wredundant-decls -O2 -g -DNDEBUG -fPIC   -std=gnu11 -MD -MT
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pvrdma_main.c.o
-MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-
rdmav16.dir/pvrdma_main.c.o.d -o
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-
rdmav16.dir/pvrdma_main.c.o   -c ../providers/vmw_pvrdma/pvrdma_main.c
FAILED: providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-
rdmav16.dir/pvrdma_main.c.o 
/usr/bin/cc -Dvmw_pvrdma_rdmav16_EXPORTS -Iinclude
-I/usr/include/libnl3 -g -O2 -fdebug-prefix-map=/<<PKGBUILDDIR>>=.
-fstack-protector-strong -Wformat -Werror=format-security -Wdate-time
-D_FORTIFY_SOURCE=2 -Wall -Wextra -Wno-sign-compare -Wno-unused-
parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings
-Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition
-Wredundant-decls -O2 -g -DNDEBUG -fPIC   -std=gnu11 -MD -MT
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pvrdma_main.c.o
-MF providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-
rdmav16.dir/pvrdma_main.c.o.d -o
providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-
rdmav16.dir/pvrdma_main.c.o   -c ../providers/vmw_pvrdma/pvrdma_main.c
In file included from ../providers/vmw_pvrdma/pvrdma_main.c:46:0:
../providers/vmw_pvrdma/pvrdma.h: In function ‘pvrdma_write_uar_srq’:
../providers/vmw_pvrdma/pvrdma.h:244:20: error: ‘PVRDMA_UAR_SRQ_OFFSET’
undeclared (first use in this function); did you mean
‘PVRDMA_UAR_CQ_OFFSET’?
  *(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) = htole32(value);
                    ^~~~~~~~~~~~~~~~~~~~~
                    PVRDMA_UAR_CQ_OFFSET
../providers/vmw_pvrdma/pvrdma.h:244:20: note: each undeclared
identifier is reported only once for each function it appears in

Ubuntu 18.04 amd64 build log:
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+buil
d/13727961/+files/buildlog_ubuntu-bionic-amd64.rdma-
core_16~201711132208~ubuntu18.04.1_BUILDING.txt.gz

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
