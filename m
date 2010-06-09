From: "Guay Wei Lin" <weilin-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: RE: MPI traffic with service Level
Date: Wed, 9 Jun 2010 16:00:07 +0200
Message-ID: <000101cb07dc$14fa2b10$3eee8130$@no>
References: <000301cb074d$be1e63d0$3a5b2b70$@no> <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE8D2@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE8D2-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, Sean! It's working for me now. 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
Sent: Wednesday, June 09, 2010 12:16 AM
To: Guay Wei Lin; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: MPI traffic with service Level 

> I'm interested in the MPI traffic that take into the consideration of the
> SL(service level)-Path mapping (as decided by SA/SM). For e.g LASH routing
> algorithm that uses SL/VL as the deadlock avoidance for routing. Is there
> any way that I can make MPI traffic that uses the SL that as indicated by
> the SA/SM? Any help/hints would be appreciated. Thanks again.

If MPI is set to use the rdma_cm, it will obtain SL information from the SA.
I believe most MPIs support this option through some means.  Beyond that,
there may be other ways to do this based on the MPI that you're using.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
