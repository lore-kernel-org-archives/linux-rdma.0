From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
Date: Thu, 25 Jul 2013 06:26:19 -0400
Message-ID: <51F0FD4B.5050503@dev.mellanox.co.il>
References: <20130724144426.5a63669ea6107c8a3e6c1867@intel.com> <51F04E2D.9060708@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E021B0B9D@CRSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237384567CA1@ORSMSX109.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E021B1099@CRSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237384567D00@ORSMSX109.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E021B1166@CRSMSX101.amr.corp.intel.com> <51F0DFBE.10608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F0DFBE.10608-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/25/2013 4:20 AM, Bart Van Assche wrote:
> On 07/25/13 01:05, Weiny, Ira wrote:
>>> -----Original Message-----
>>> From: Hefty, Sean
>>> Subject: RE: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
>>>
>>>>>>> See Annex 8; DevMgt class version 2 rather than 1 is currently
>>> supported.
>>>>>>
>>>>>> Could older devices still return version 1?  If so the kernel
>>>>>> should allow DevMgt without RMPP, correct?
>>>>>
>>>>> This check has been this way since 2.6.17.  I think it's reasonable
>>>>> to say
>>>> that
>>>>> there aren't any devices using version 1 that are running with Linux.
>>>>
>>>> FWIW the ib_srpt module uses a class version of 1:
>>>>
>>>> Ib_srpt.c:
>>>>
>>>> ...
>>>>         reg_req.mgmt_class_version = IB_MGMT_BASE_VERSION;
>>> ...
>>>
>>> So, then this just happens to work because of some other check?  If
>>> that's so,
>>> then I agree with Hal, in that we can add the class version to the
>>> check.
>>
>> I think this works because the MAD stack triggers off of rmpp_version
>> (in the
>> agent) and RMPP_ACTIVE (in the individual MAD's).  Since rmpp_version
>> == 0 in this registration and likely all the MAD sent have a 0'ed out
>> RMPP Header (ie the MAD stack thinks all MADs are RMPP _in_active) I
>> think  the stack passes all the MAD's without invoking the RMPP
>> processing.
> 
> Changing the mgmt_class_version in ib_srpt.c from 1 into 2 would break
> existing SRP device management clients (srp_daemon and ibsrpdm) since
> these set mgmt_class_version to 1.
> 
> I'm not sure changing the rmpp_version argument in the
> ib_register_mad_agent() call in ib_srpt.c would be sufficient to enable
> RMPP for DM MAD's. Wouldn't the clients (srp_daemon and ibsrpdm) have to
> be updated as well to set the rmpp_version in the MAD header as well ?

There's a whole set of rules on DevMgt class version backward
compatibility in Annex A8.

I think it's simpler to continue use of class version 1 for DevMgt.

There may be a modification to the kernel MAD module to indicate that
for DevMgt class version 1 is not RMPP capable whereas class version 2
is. I think that's the only takeaway. This should have no impact on any
DevMgt clients.

-- Hal


> Bart.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
