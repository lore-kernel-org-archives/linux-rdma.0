From: Edward Mascarenhas <eddiem-sJ/iWh9BUns@public.gmane.org>
Subject: ibdiagpath return code incorrect
Date: Fri, 16 Oct 2009 16:15:54 -0700
Message-ID: <4AD8FEAA.101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It appears that even on error ibdiagpath is returning zero but it
should return non-zero for error cases. Scripts that call ibdiagpath
can use the return code to take appropriate action.

Here is an example.

==================================================
service0: # ibdiagpath -i 1 -d 1,12
Loading IBDIAGPATH from: /usr/lib64/ibdiagpath1.2
-W- Topology file is not specified.
    Reports regarding cluster links will use direct routes.
Loading IBDM from: /usr/lib64/ibdm1.2
-I- Using port 1 as the local port
    (since that is the output port based on the provided direct route).

-I---------------------------------------------------
-I- Traversing the path from local to destination
-I---------------------------------------------------
-I- From: lid=0x000c guid=0x0002c90200291949 dev=25218 service0/P1
-I- To:   lid=0x001d guid=0x0800690000005264 dev=48438 Port=28


can't read "PATH(1)": no such element in array

service0:/tmp/src # echo $?
0
service0:/tmp/src #
================================================

Assuming this is a bug, I don't have a fix, but I'm hoping someone who
is more familiar with the ibdiagpath code will provide a fix.

Thanks,
Edward
