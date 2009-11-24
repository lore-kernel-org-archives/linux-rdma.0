From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Mon, 23 Nov 2009 17:57:16 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911231745350.1226@desktop>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop>
 <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6A30FB8CEED94D778E7CDAE4660458DA-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 16 Nov 2009, Sean Hefty wrote:

>> Is there an opensource example of using APM?  When I call ib_cm_send_lap()
>> the QP goes to some error state and my connections die.  Do I need to set
>> some QP attributes first?  I found a paper that describes the process but
>> does not contain sample code or any real details.
>
> Sending the LAP/APR only exchanges CM protocol messages.  You still need to
> modify the QP.  There's an old example program for the kernel that did APM, but
> it shouldn't be too hard to see what it did and convert it to a userspace app.
>
> See the cmpost sample in the test-apps branch of my rdma-dev.git tree.

Thank you.  This worked for me.  However, there seems to be some kind of 
race when the connection is first set up.  On the client if I call 
ib_cm_send_lap() immediately after ib_cm_send_rtu() returns successfully I 
get an EINVAL error.  If I delay for one second it works just fine. 
According to the spec the passive/server side can not send the lap so I 
can't send it in the rtu handler.  Presumably the call fails immediately 
after send_rtu because the server hasn't received that message yet?  Is 
this right?  Is there a way to do this cleanly without a delay?

I notice that if I create the initial attributes for the connection 
request with an alternate path specified the alt_path_state is still 
MIGRATED when I send rtu.  If I load a path after the connection is 
established I can fail back and forth without issue.

Thanks,
Jeff

>
http://www.openfabrics.org/git/?p=~shefty/rdma-dev.git;a=blob;f=drivers/infiniba
nd/util/cmpost/cmpost.c;h=99f1446af841fd34b50b7bdfce1360f741e10a63;hb=b5e668a9b6
d0f24d1a92e604e67c44f1452ea1e4
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
