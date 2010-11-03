From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] Add exponential backoff + random delay to MADs when
 retrying after timeout.
Date: Wed, 3 Nov 2010 09:03:01 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8308894@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB@MNEXMB1.qlogic.org>
 <4CC976CC.1080009@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83084D5@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A207A813F@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A207A813F-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hal asked the same thing - and I'm confused because I thought
> that if receiving an RMPP response times out, the entire transaction is
> aborted.

RMPP still uses retries.  If the user specifies a timeout of 1 second, with 3 retries, _each_ RMPP window will be retried up to 3 times, waiting for an ACK.  Once an ACK is received, the next window can be retried up to 3 times, with a 1 second timeout per ACK, etc.  It looks like your patch increments the timeout, and the increment is maintained across windows.

> I'm open to this, but do we really need TCP/IP level congestion
> control? How many nodes are likely to have more than a few SA
> queries outstanding at a time?

With large MPI job startup, we could have hundreds or thousands of SA queries issued from a single node.  Even if the number of requests per node is small, the intent is to have all nodes back off from flooding the SA.  So, I would say, yes, we want something like TCP congestion control.  A delay in a response seems more likely to be a result in the SA being flooded with requests than an actual packet being dropped.

This would also allow a node to delay sending any SA query after receiving a busy response to one.  Caching data can help here, but we get the data from the SA first, plus still be able to handle errors, topology changes, QoS, etc.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
