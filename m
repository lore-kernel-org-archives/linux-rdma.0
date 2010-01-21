From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Thu, 21 Jan 2010 10:26:08 +0100
Message-ID: <20100121102608.65965f95@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<ada6376ndgs.fsf@roland-alpha.cisco.com>
	<20100114135815.69d5a9a5@frecb007965>
	<ada3a28mwdw.fsf@roland-alpha.cisco.com>
	<20100115084102.2258eba8@frecb007965>
	<adaiqax37g4.fsf@roland-alpha.cisco.com>
	<20100120085530.5d675ef8@frecb007965>
	<4B56B8E3.3010909@voltaire.com>
	<20100120101717.60d733e3@frecb007965>
	<4B572099.3030604@Voltaire.com>
	<20100121092840.7429e81f@frecb007965>
	<4B581A68.500@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B581A68.500-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Jan 2010 11:12:08 +0200
Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> wrote:

> sebastien dugue wrote:
> > OK, then going with the TCP port space, what we need in OpenSM is a
> > combination of service id (TCP) _and_ TCP port _and_ target GUID.
> 
> I believe that you can have a 'lustre' keyword in opensm qos parser which stands for the combination of tcp port space + lustre tcp port (maybe it exists now), so in the policy file this would translate to X,{Z1,Z2,..,Zm} (as was in your example) and not to X,Y,{Z1,Z2,..,Zm}.

  Right, that'd be a nice shortcut. I also think being able to specify both port
and target GUID to the TCP port space might be interesting for other ULPs, not
just Lustre.

  Sebastien.
 
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
