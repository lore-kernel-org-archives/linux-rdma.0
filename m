From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH opensm] Implement atomic update operation for sa_db_file
Date: Fri, 22 Nov 2013 09:57:00 -0500
Message-ID: <528F70BC.1050907@dev.mellanox.co.il>
References: <5283A88D.9020608@dev.mellanox.co.il> <5283BE32.5070804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5283BE32.5070804-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 11/13/2013 1:00 PM, Bart Van Assche wrote:
> Isn't an fdatasync() call missing after dump_func() and before fclose()
> ? According to Theodore Ts'o calling fdatasync() or fsync() before
> fclose() is essential during an atomic update. See also
> http://thunk.org/tytso/blog/2009/03/15/dont-fear-the-fsync/ for more
> information.

Thanks for the pointer. Yes, an fsync is appropriate here. Do you want
to send a patch for that or should I just cruft one up ?

-- Hal

> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
