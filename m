From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from
	userspace
Date: Thu, 13 May 2010 08:55:13 -0700
Message-ID: <8172EB57F9DF4F93BBFAD583235E8C3F@amr.corp.intel.com>
References: <20100218172425.GH12286@mtls03>	<adak4r8uaog.fsf@roland-alpha.cisco.com>
	<20100513135645.GL16073@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20100513135645.GL16073-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Address mapping policies depend on the address type. This patch only
>defines a policy for mapping link-local addresses, and we should
>indeed take care not to change it (if possible).
>Later on, we can add more policies for other address types (e.g.,
>normal IPv6 addresses, mapped IPv4 addresses, etc.)
>>
>> Or maybe it is device-specific, and we could wrap it up into the create
>> AH uverbs call we already have?
>
>Interesting idea. Not sure what is better here: a seperate ABI
>call or some additional 'u8 ctx[32]' field in struct
>ib_uverbs_create_ah_resp that will be interpreted by the hw-specific
>user-space driver.

I don't understand why mapping remote addresses should be driver specific.
