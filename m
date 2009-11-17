From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Mon, 16 Nov 2009 21:15:47 -0800
Message-ID: <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.0911161835230.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Roberson' <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Is there an opensource example of using APM?  When I call ib_cm_send_lap()
>the QP goes to some error state and my connections die.  Do I need to set
>some QP attributes first?  I found a paper that describes the process but
>does not contain sample code or any real details.

Sending the LAP/APR only exchanges CM protocol messages.  You still need to
modify the QP.  There's an old example program for the kernel that did APM, but
it shouldn't be too hard to see what it did and convert it to a userspace app.

See the cmpost sample in the test-apps branch of my rdma-dev.git tree.

http://www.openfabrics.org/git/?p=~shefty/rdma-dev.git;a=blob;f=drivers/infiniba
nd/util/cmpost/cmpost.c;h=99f1446af841fd34b50b7bdfce1360f741e10a63;hb=b5e668a9b6
d0f24d1a92e604e67c44f1452ea1e4

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
