From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/3] IB/SRP patches for kernel 3.8
Date: Thu, 20 Dec 2012 16:56:03 +0200
Message-ID: <50D32703.2030602@mellanox.com>
References: <50D1CD49.5080607@acm.org> <50D306DE.7080505@mellanox.com> <50D3105C.10005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D3105C.10005-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/12/2012 15:19, Bart Van Assche wrote:
> On 12/20/12 13:38, Or Gerlitz wrote:
>> I think few days ago you had a patch on your tree named "Save and
>> restore host_scribble during error handling", is it possible we need
>> this here for happy removal of the scsi host?
>
> No. Host removal works fine even without that patch. 

not on my setup, how do you suggest to proceed here?

Or.

> That's because srp_abort() has been modified such that it finishes a 
> request whether or not sending a task management function to the 
> target succeeded. As you can see in scsi_eh_abort_cmnds() if the 
> eh_abort_handler callback function returns SUCCESS then 
> scsi_eh_test_devices() will be passed an empty work_q list. Hence the 
> SCSI error handler function scsi_eh_prep_cmnd() does not get invoked 
> and hence does not have a chance of overwriting the host_scribble field.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
