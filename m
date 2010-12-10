From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] ibacm-1.0.4 release
Date: Fri, 10 Dec 2010 12:46:19 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C8C2EF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibacm is a daemon that provides address and route (path) resolution services over Infiniband.

The new release, 1.0.4, is available from:

	http://www.openfabrics.org/downloads/rdmacm/ibacm-1.0.4.tar.gz

with sha1sum

	25a8a2bf330060c40b83fc31fca831a407b7f667  ibacm-1.0.4.tar.gz

The git shortlog since 1.0.3 is:

Sean Hefty (21):
      ibacm: enhance debug messages
      ibacm: fix issuing SA query after recording address
      ibacm: Introduce loopback resolution 'protocol'
      ibacm: fixup white space in text
      ibacm: add cfg files to distribution
      ibacm: decrease default retries
      ibacm: Add lock to prevent multiple daemons from running
      ib_acme: Hide output for -A -O options unless verbose
      ibacm: modify logging output
      ibacm: automatically generate addresses if missing acm_addr.cfg
      ibacm: write port to /var/run/ibacm.port
      ibacm: support no delay options
      ib_acme: allow source to be optional parameter
      ib_acme: convert error to readable string
      ib_acme: Allow user to specify multiple destinations
      ib_acme: add an 'unspecified' address format
      ib_acm: merge acm_notes.txt into ib_acm man page
      ib_acm: change default log file
      ibacm: remove unused acm_msg.h file
      ibacm: check destination type when selecting source
      v1.0.4
--

Vlad, please pull this into OFED 1.5.3.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
