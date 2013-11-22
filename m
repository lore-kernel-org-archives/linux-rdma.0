From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH opensm] Implement atomic update operation for sa_db_file
Date: Fri, 22 Nov 2013 16:27:37 +0100
Message-ID: <528F77E9.90004@acm.org>
References: <5283A88D.9020608@dev.mellanox.co.il> <5283BE32.5070804@acm.org> <528F70BC.1050907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528F70BC.1050907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/22/13 15:57, Hal Rosenstock wrote:
> Hi Bart,
> 
> On 11/13/2013 1:00 PM, Bart Van Assche wrote:
>> Isn't an fdatasync() call missing after dump_func() and before fclose()
>> ? According to Theodore Ts'o calling fdatasync() or fsync() before
>> fclose() is essential during an atomic update. See also
>> http://thunk.org/tytso/blog/2009/03/15/dont-fear-the-fsync/ for more
>> information.
> 
> Thanks for the pointer. Yes, an fsync is appropriate here. Do you want
> to send a patch for that or should I just cruft one up ?

If you can look into this that's fine for me. I'm already involved in
too many different open source projects :-)

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
