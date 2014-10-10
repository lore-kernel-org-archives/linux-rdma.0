From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Fri, 10 Oct 2014 10:37:34 +0530
Message-ID: <ec59646f09a80e3e61ce428b8dd87ce0@imap.linux.ibm.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
 <56553bcab94dc48bde61d36ae9eb5eaa@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE7AE7@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DE7AE7-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason & Sean,

POSIX recv() manual page describes behavior as follows (reproduced here 
for convenience) -

http://linux.die.net/man/3/recv

==========
Return Value

Upon successful completion, recv() shall return the length of the 
message in bytes. If no messages are available to be received and the 
peer has performed an orderly shutdown, recv() shall return 0. 
Otherwise, -1 shall be returned and errno set to indicate the error.

Errors

The recv() function shall fail if:

ECONNRESET
     A connection was forcibly closed by a peer.
==========

So the current behavior of returning 0 is wrong as there was no orderly 
shutdown performed on the other end before a close() is issued [ 
http://stackoverflow.com/questions/5879560/how-can-i-cause-an-econnreset-in-recv-from-a-client 
].

Thank You.

- Sreedhar


On 2014-10-09 22:14, Hefty, Sean wrote:
>> Thanks for the fix.  Now, we are able to see the similar behavior
>> between tcp/ip and rsockets when the other end is suddenly closed
>> while waiting on data.
> 
> Can you read and respond to Jason's comments on this patch?
> 
>> That isn't the whole story though - you only get ECONNRESET in some
>> cases, and it is OS dependent.
> 
>> stackoverflow suggets:
> 
>> http://stackoverflow.com/questions/2974021/what-does-econnreset-mean-in-the-context-of-an-af-local-socket
> 
>> Which looks reasonable to me and matches my experience with socket
>> programming on Linux. The Steven's book might have some authoritative
>> clarifications on the subject as well.
> 
> Based on this information, it's not clear that the current behavior of
> returning 0 is wrong.
> 
> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
