From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Fri, 10 Oct 2014 11:45:47 -0600
Message-ID: <20141010174547.GA10189@obsidianresearch.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
 <56553bcab94dc48bde61d36ae9eb5eaa@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE7AE7@ORSMSX109.amr.corp.intel.com>
 <ec59646f09a80e3e61ce428b8dd87ce0@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ec59646f09a80e3e61ce428b8dd87ce0-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 10, 2014 at 10:37:34AM +0530, Sreedhar Kodali wrote:
> So the current behavior of returning 0 is wrong as there was no
> orderly shutdown performed on the other end before a close() is
> issued

'Orderly shutdown' is any call of close() when there is no data in the
recv queue, or shutdown(SHUT_WR).

> http://stackoverflow.com/questions/5879560/how-can-i-cause-an-econnreset-in-recv-from-a-client

This accepted answer is not correct, close on its own does not
generate ECONNRESET.

This is trivally shown with strace and a bit of python:

server:
 import socket
 s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
 s.bind(("127.0.0.1",9090))
 s.listen(1)
 conn, addr = s.accept()
 conn.recv(1024)

client:

import socket
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("127.0.0.1",9090))
s.close()

Result:

[..]
accept(3, {sa_family=AF_INET, sin_port=htons(41284), sin_addr=inet_addr("127.0.0.1")}, [16]) = 4
recvfrom(4, "", 1024, 0, NULL, NULL)    = 0

ECONNRESET signals a special condition that it seems rsockets cannot
detect, as it doesn't have the one sided close semantics of TCP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
