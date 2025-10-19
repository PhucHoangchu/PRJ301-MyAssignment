USE [master]
GO
/****** Object:  Database [PRJ_Assignment]    Script Date: 10/20/2025 2:12:20 AM ******/
CREATE DATABASE [PRJ_Assignment]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PRJ_Assignment', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.GIAOLANG\MSSQL\DATA\PRJ_Assignment.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PRJ_Assignment_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.GIAOLANG\MSSQL\DATA\PRJ_Assignment_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PRJ_Assignment] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PRJ_Assignment].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PRJ_Assignment] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET ARITHABORT OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PRJ_Assignment] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PRJ_Assignment] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PRJ_Assignment] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PRJ_Assignment] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PRJ_Assignment] SET  MULTI_USER 
GO
ALTER DATABASE [PRJ_Assignment] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PRJ_Assignment] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PRJ_Assignment] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PRJ_Assignment] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PRJ_Assignment] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PRJ_Assignment] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PRJ_Assignment] SET QUERY_STORE = ON
GO
ALTER DATABASE [PRJ_Assignment] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PRJ_Assignment]
GO
/****** Object:  Table [dbo].[Division]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Division](
	[did] [int] NOT NULL,
	[dname] [varchar](150) NOT NULL,
 CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
(
	[did] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[eid] [int] NOT NULL,
	[ename] [varchar](150) NOT NULL,
	[did] [int] NOT NULL,
	[supervisorid] [int] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollment]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollment](
	[uid] [int] NOT NULL,
	[eid] [int] NOT NULL,
	[active] [bit] NOT NULL,
 CONSTRAINT [PK_Enrollment] PRIMARY KEY CLUSTERED 
(
	[uid] ASC,
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feature]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feature](
	[fid] [int] NOT NULL,
	[url] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Feature] PRIMARY KEY CLUSTERED 
(
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequestForLeave]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestForLeave](
	[rid] [int] NOT NULL,
	[created_by] [int] NOT NULL,
	[created_time] [datetime] NOT NULL,
	[from] [date] NOT NULL,
	[to] [date] NOT NULL,
	[reason] [varchar](max) NOT NULL,
 CONSTRAINT [PK_RequestForLeave] PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[rid] [int] NOT NULL,
	[rname] [varchar](150) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleFeature]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleFeature](
	[rid] [int] NOT NULL,
	[fid] [int] NOT NULL,
 CONSTRAINT [PK_RoleFeature] PRIMARY KEY CLUSTERED 
(
	[rid] ASC,
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[uid] [int] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](150) NULL,
	[displayname] [varchar](150) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 10/20/2025 2:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[uid] [int] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Feature] ([fid], [url]) VALUES (1, N'/request/create')
GO
INSERT [dbo].[Feature] ([fid], [url]) VALUES (2, N'/request/review')
GO
INSERT [dbo].[Feature] ([fid], [url]) VALUES (3, N'/request/list')
GO
INSERT [dbo].[Feature] ([fid], [url]) VALUES (4, N'/division/agenda')
GO
INSERT [dbo].[Role] ([rid], [rname]) VALUES (1, N'IT Head')
GO
INSERT [dbo].[Role] ([rid], [rname]) VALUES (2, N'IT PM')
GO
INSERT [dbo].[Role] ([rid], [rname]) VALUES (3, N'IT Employee')
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 1)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 2)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 3)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 4)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 1)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 2)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 3)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 1)
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 3)
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (1, N'mra', N'123', N'Mr A  - Division Leader')
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (2, N'mrb', N'123', N'Mr B - Manager')
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (3, N'mrc', N'123', N'Mr C - Manager')
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (4, N'mrd', N'123', N'Employee MrD')
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (5, N'mre', N'123', N'Employee MrE')
GO
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (6, N'mrg', N'123', N'Unassigned Role')
GO
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (1, 1)
GO
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (2, 2)
GO
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (3, 2)
GO
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (4, 3)
GO
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (5, 3)
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Division] FOREIGN KEY([did])
REFERENCES [dbo].[Division] ([did])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Division]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Employee] FOREIGN KEY([supervisorid])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Employee]
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD  CONSTRAINT [FK_Enrollment_Employee] FOREIGN KEY([eid])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_Enrollment_Employee]
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD  CONSTRAINT [FK_Enrollment_User] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_Enrollment_User]
GO
ALTER TABLE [dbo].[RequestForLeave]  WITH CHECK ADD  CONSTRAINT [FK_RequestForLeave_Employee] FOREIGN KEY([created_by])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[RequestForLeave] CHECK CONSTRAINT [FK_RequestForLeave_Employee]
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_RoleFeature_Feature] FOREIGN KEY([fid])
REFERENCES [dbo].[Feature] ([fid])
GO
ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_RoleFeature_Feature]
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_RoleFeature_Role] FOREIGN KEY([rid])
REFERENCES [dbo].[Role] ([rid])
GO
ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_RoleFeature_Role]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([rid])
REFERENCES [dbo].[Role] ([rid])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_User]
GO
USE [master]
GO
ALTER DATABASE [PRJ_Assignment] SET  READ_WRITE 
GO
