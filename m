From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: systemd unit file location...
Date: Thu, 20 Oct 2016 05:04:35 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24F0E61D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Jason Gunthorpe (jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org)'" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Why is this:

./build/CMakeCache.txt:CMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/usr/local/lib/systemd

Not defined as:

./build/CMakeCache.txt:CMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/usr/local/lib/systemd/system

??

And you add the "system" in the Debian rules?

./debian/iwpmd.install:lib/systemd/system/iwpmd.service
./debian/rules:                 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/lib/systemd/system \

I believe the same "system" sub dir is used on Fedora and RHEL, not sure about other distros?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
