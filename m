From: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Subject: Re: Leak in rdma_get_cm_event on pthread_cancel?
Date: Fri, 13 Jan 2012 17:55:02 +0100
Message-ID: <4F1061E6.70901@list-group.com>
References: <4F101978.6010608@list-group.com> <1828884A29C6694DAF28B7E6B8A8237325676E37@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325676E37-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Il 1/13/2012 17:43 PM, Hefty, Sean ha scritto:
>> When I want to stop the thread reading rdma events, I kill it with a
>> pthread_cancel(), since it is blocked in a
>> rdma_get_cm_event(). This causes a leak of the evt variable in the
>> rdma_get_cm_event() function. Not a big deal, of
>> course, but a couple of pthread_cleanup_push(free, evt) and
>> pthread_cleanup_pop() should solve it.
>
> What version of the librdmacm are you using?

I'm using 1.0.13; I checked in 1.0.15 too, and the code appears to have the same structure.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
