From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
Date: Thu, 22 Dec 2016 13:17:00 -0500
Message-ID: <bf346322-4ef4-032d-9ea2-5a63ae7737e5@redhat.com>
References: <20161222180220.49558-1-jarod@redhat.com>
 <20161222181323.GA5053@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222181323.GA5053-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-22 1:13 PM, Jason Gunthorpe wrote:
> On Thu, Dec 22, 2016 at 01:02:20PM -0500, Jarod Wilson wrote:
>> These are numerous additional little fixups for the Fedora/Red Hat spec
>> file, stemming from Fedora package review.
>>
>> - Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
>>   have systemd as a BuildRequires for %{_unitdir} to evaluate properly.
>>
>> - Add explicit dependencies on kmod, initscripts and systemd, as there
>>   are container and vm cases where there might not be a kernel
>>   installed
>
> Do we need initscripts?

Not really sure, the Fedora package reviewer insists we do.

>> - Make sure srp_daemon.sh is executable
>
> Oops, lets fix that commonly please, can you roll this in and drop the chmod:
>
> diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
> index f2752a8e6e1580..acb851bcb8a438 100644
> --- a/srp_daemon/CMakeLists.txt
> +++ b/srp_daemon/CMakeLists.txt
> @@ -22,7 +22,8 @@ rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/ibsrpdm")
>  rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/run_srp_daemon")
>  rdma_subst_install(FILES "srp_daemon.sh.in"
>    DESTINATION "${CMAKE_INSTALL_SBINDIR}"
> -  RENAME "srp_daemon.sh")
> +  RENAME "srp_daemon.sh"
> +  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)

Ah, yeah, that's much better. Crap, hit send on v2 just as your mail 
came in. I guess I'll spin up a v3 momentarily.

>>  Requires: %{name}%{?_isa} = %{version}-%{release}
>> +Requires: logrotate
>
> I don't think we use logrotate for anything unless the srp rsyslog
> examples are being used? Maybe it would be better to move the logrotate
> and rsyslog stuff to doc/examples or something?

This is another one where the package reviewer seems insistent.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
