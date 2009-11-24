From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Tue, 24 Nov 2009 09:49:09 -0800
Message-ID: <10477AA8CF094F2F92E8792307982F66@amr.corp.intel.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop> <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com> <alpine.BSF.2.00.0911231745350.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.0911231745350.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Roberson' <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Thank you.  This worked for me.  However, there seems to be some kind of
>race when the connection is first set up.  On the client if I call
>ib_cm_send_lap() immediately after ib_cm_send_rtu() returns successfully I
>get an EINVAL error.  If I delay for one second it works just fine.

ib_cm_send_lap() returning EINVAL should indicate an immediate error, so this
should be an issue with the local side.  It sounds like a possible bug in the
code, but I didn't see anything obvious from a quick look at the code.

>According to the spec the passive/server side can not send the lap so I
>can't send it in the rtu handler.  Presumably the call fails immediately
>after send_rtu because the server hasn't received that message yet?  Is
>this right?  Is there a way to do this cleanly without a delay?

I don't know that the code enforces that the passive side not send a LAP, (and
can't think of a reason why the protocol should have such a restriction.)  It
may work.  But, rather than sending a separate LAP immediately after connecting,
why not include the alternate path in the original REQ?

>I notice that if I create the initial attributes for the connection
>request with an alternate path specified the alt_path_state is still
>MIGRATED when I send rtu.  If I load a path after the connection is
>established I can fail back and forth without issue.

Can you clarify this a little more?  What specific field are you looking at and
what state are you seeing it set to?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
