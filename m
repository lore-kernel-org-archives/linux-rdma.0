From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Crash in bonding
Date: Tue, 03 Nov 2009 09:40:29 -0800
Message-ID: <4AF06B0D.5070709@linux.vnet.ibm.com>
References: <4AEF6020.7000806@linux.vnet.ibm.com><1257252696.13991.5.camel@linux-nzha.site>
	<4AF05D9B.30807@linux.vnet.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA01AB635F@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <39C75744D164D948A170E9792AF8E7CA01AB635F-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, fubar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Shiri Franchi wrote:
> Hi,
> 
> I did it exactly as you described:
> 1. ifdown ib0
> 2. ifdown ib1
> 3. modprobe -r ib_ipoib
> 
> And it did not reproduced..

It is a race that you may not be recreating. I have tried
this across different HCAs and platforms (x86_64, ppc64). 
Seems to recreate almost at will for me.

Pradeep
