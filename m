From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Tue, 1 Dec 2009 07:55:23 -0800
Message-ID: <5C167F806271443AAB2C14A6E785CDF9@amr.corp.intel.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop> <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com> <alpine.BSF.2.00.0911231745350.1226@desktop> <10477AA8CF094F2F92E8792307982F66@amr.corp.intel.com> <alpine.BSF.2.00.0911240951000.1226@desktop> <65B503E4F968463B8D6D5D019E036ED7@amr.corp.intel.com> <alpine.BSF.2.00.0911301407180.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.0911301407180.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Roberson' <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Really it looks as if this check should be predicated on the actual QP
>state which we don't seem to have at this time.  The CM state also doesn't
>seem to be useful as it is already ESTABLISHED in this case.
>
>Any suggestions?

Given the current code, you could transition to RTS before sending the REP,
rather than waiting until you receive the RTU.  As long as you don't actually
send until the RTU arrives, it should be fine.  Alternatively, you can
initialize the QP attribute structure without calling the CM helper functions.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
