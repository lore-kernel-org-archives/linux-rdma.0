From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Possible process deadlock in RMPP flow
Date: Thu, 24 Sep 2009 09:38:43 +0300
Message-ID: <4ABB13F3.1060702@Voltaire.com>
References: <20090923150454.GA26150@mtls03>	<7A32EEE20DF5432CADB60B8F8B1E0093@amr.corp.intel.com>
	<20090923172532.GA32223@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20090923172532.GA32223@mtls03>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> On Wed, Sep 23, 2009 at 09:08:28AM -0700, Sean Hefty wrote:
>> What kernel does 1.4.2 map to?
> I think OFED 1.4.2 is based on kernel 2.6.27 but they're using RHEL 5.3

Yes, the usual mess: ofed X is based on kernel Y1 but with some additions from kernel Y2 plus plenty of unreviwed and non-merged patches. Distro Z picks ofed X and the result is 99% unsupportable as Roland said. Somehow this ofed creature is still hanging around working on the the next damage its going to bring into this world (code name 1.5)

Eli, here's a little tip for you, I had the displeasure to resolve bunch of support cases originating from the fact that the below 2 years old commit missed some ofed version (sorry forgot the number...), maybe it would help you as well?

Under a normal setting, if this commit actually solves a bug being hit by many costumers, someone would have opened a distro bugzilla case saying, "please pick this commit for your kernel", the customers would have either wait for the next distro update or use a distro intermediate kernel. Currently, I understand that distros are picking ofed versions and that's it.

Or.

commit b61d92d8ae6aa13b17d1c31e69d123879cec2ee2
Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Nov 30 17:30:18 2007 -0800

    IB/mad: Fix incorrect access to items on local_list
