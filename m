From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: iSER Connection via LIO not working
Date: Thu, 8 Jun 2017 16:35:24 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3431F91D@fmsmsx120.amr.corp.intel.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
         <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
         <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
         <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
         <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
         <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
         <1790271E-1A6B-492D-B4B6-701873B23A01@creamfinance.com>
         <32E1700B9017364D9B60AED9960492BC3431F8F1@fmsmsx120.amr.corp.intel.com>
 <1496939302.3028.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496939302.3028.3.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org" <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Bart Van Assche [mailto:Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
> Sent: Thursday, June 8, 2017 12:28 PM
> To: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org; thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org;
> Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: iSER Connection via LIO not working
> 
> On Thu, 2017-06-08 at 16:23 +0000, Marciniszyn, Mike wrote:
> > This appears to be the only storage ULP that reads this field exported from
> drivers.
> 
> Hello Mike,
> 
> Are you sure of this? This is what grep tells me:
> 

I only checked within ulp.    Perhaps it is a wider issue.

srp appears to only use the variable when use_fast_reg is set, which looks to be based on the device exported bit.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
