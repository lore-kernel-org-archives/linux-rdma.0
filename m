From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [OPENSM] match functions to prototypes in header file
Date: Thu, 1 Oct 2009 14:13:48 -0600
Message-ID: <20091001201348.GK19540@obsidianresearch.com>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com> <20091001183127.GX17846@me> <20091001185148.GJ19540@obsidianresearch.com> <4D838DBAE5F245EEA72D4466987294E1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D838DBAE5F245EEA72D4466987294E1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 12:52:21PM -0700, Sean Hefty wrote:
> >> > @@ -1106,9 +1109,9 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN
> >const ib_path_rec_t * p_pr,
> >> >  			"\t\t\t\tresv2...................0x%X\n"
> >> >  			"\t\t\t\tresv3...................0x%X\n",
> >> >  			cl_ntoh64(p_pr->service_id),
> >> > -			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
> >> > +			inet_ntop(AF_INET6, (void*)p_pr->dgid.raw, gid_str,
> >>
> >> And why is such casting(s) needed?
> >
> >Casting away const like that is incorrect, fix your inet_ntop to have
> >a POSIX signature or ignore the warning.
> 
> The WinOF version of inet_ntop is:
> 
> const char *inet_ntop(int af, const void *src, char *dst, socklen_t cnt);
> 
> The MS version of inet_ntop (available in vista and later) is:
> 
> "The ANSI version of this function is inet_ntop"
> PCTSTR WSAAPI InetNtop(
>   __in   INT  Family,
>   __in   PVOID pAddr,
>   __out  PTSTR pStringBuf,
>   __in   size_t StringBufSize
> );
> 
> I'm guessing inet_ntop maps directly to InetNtop, but I can't find the
> definition in the header file.  We use the MS version of the function when
> available.

Well, if windows header files are providing inet_ntop with the wrong
signature you are kinda stuck, pretty crummy thing for MS to do really.

I've fixed things like this via this approach before:

#include <windows-header.h>
#define inet_ntop my_inet_ntop
static inline const char *my_inet_ntop(int af, const void *src,
                                       char *dst, socklen_t size)
{
   return InetNtop(af,(void *)src,dst,size);
}

With #include_next it can be pretty transparent.

Hey, I ran into this the other day:

http://www.gnu.org/software/gnulib/

I wonder if it is something that might help your efforts?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
