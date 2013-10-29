From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: smatch  warnings on the IB core
Date: Tue, 29 Oct 2013 09:03:16 +0200
Message-ID: <526F5DB4.9020401@mellanox.com>
References: <526CB685.40607@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF16CC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF16CC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/10/2013 18:32, Hefty, Sean wrote:
> Visually inspecting the code for both of these, I don't see anything wrong.  In both cases the listen mutex is acquired near the top of the function and released at the end.  I don't see how you exit either function with the mutex locked.
>
> In the top case, line 1271 is a return statement that occurs before we've acquired the mutex.  Line 1274 is an abort case where we acquire the mutex, check a state, release the mutex, and return.

Dan, do you agree this is false-positive? anything we can do to teach 
smatch not to shout on that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
