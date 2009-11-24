From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Tue, 24 Nov 2009 11:59:14 -0800
Message-ID: <65B503E4F968463B8D6D5D019E036ED7@amr.corp.intel.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop> <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com> <alpine.BSF.2.00.0911231745350.1226@desktop> <10477AA8CF094F2F92E8792307982F66@amr.corp.intel.com> <alpine.BSF.2.00.0911240951000.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.0911240951000.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Roberson' <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>That's what I suspected.  I wonder if the connection state isn't set
>properly until later?  I'm really not sure.  Without a kernel debugger
>it'll be hard to determine.  I guess I can throw some printfs in to track
>this down unless there are better suggestions.

Adding some printk's to ib_send_cm_lap() may be sufficient.  I would look at the
cm_id state (should be IB_CM_ESTABLISHED) and the lap_state (should be
IB_CM_LAP_UNINT the first time it's called).

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
