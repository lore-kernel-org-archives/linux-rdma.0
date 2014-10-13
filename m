From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Mon, 13 Oct 2014 09:21:45 +0530
Message-ID: <bfbf5e83ef496220be1633272afc88e3@imap.linux.ibm.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
 <56553bcab94dc48bde61d36ae9eb5eaa@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE7AE7@ORSMSX109.amr.corp.intel.com>
 <ec59646f09a80e3e61ce428b8dd87ce0@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE9543@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DE9543-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I am fine with your conclusion.  But since R-Sockets emulates socket
functionality on top of RDMA, it would be helpful if this behavioral
difference between TCP and R-Sockets is captured as part of the user
documentation.

Thank You.

- Sreedhar

On 2014-10-10 11:04, Hefty, Sean wrote:
>> Upon successful completion, recv() shall return the length of the
>> message in bytes. If no messages are available to be received and the
>> peer has performed an orderly shutdown, recv() shall return 0.
>> Otherwise, -1 shall be returned and errno set to indicate the error.
>> 
>> Errors
>> 
>> The recv() function shall fail if:
>> 
>> ECONNRESET
>>      A connection was forcibly closed by a peer.
>> ==========
>> 
>> So the current behavior of returning 0 is wrong as there was no 
>> orderly
>> shutdown performed on the other end before a close() is issued [
>> http://stackoverflow.com/questions/5879560/how-can-i-cause-an-econnreset-
>> in-recv-from-a-client
> 
> The patch is incorrect then.  It always returns ECONNRESET.  Rsockets
> does not distinguish between the app calling shutdown versus close.
> Because everything is in user space, the disconnect message itself
> comes from the app.  The rclose call invokes rshutdown, otherwise the
> remote side will may never know that the peer is gone (which can
> happen if the app exits without calling rclose).
> 
> I'm inclined to just leave the current behavior as is.  I don't see
> why a real app would care if close performed an orderly shutdown or
> not, as this errors on the side of acting better than expected.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
